clear;
%list of images
imglist=importdata('imglist.txt');
%minimum size of face
minsize=50;

%path of toolbox
caffe_path='/home/wuwenhao/code/center_face/MTCNN/caffe/matlab';
%pdollar_toolbox_path='/home/wuwenhao/code/center_face/MTCNN/caffe/matlab/toolbox-master';
caffe_model_path='../../v1model';
addpath(genpath(caffe_path));
%addpath(genpath(pdollar_toolbox_path));

%use cpu
%caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();	
caffe.set_device(gpu_id);
caffe.reset_all();
%three steps's threshold
threshold=[0.6 0.7 0.7];

%scale factor
factor=0.709;

%load caffe models
prototxt_dir =strcat(caffe_model_path,'/det1.prototxt');
model_dir = strcat(caffe_model_path,'/det1.caffemodel');
PNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det2.prototxt');
model_dir = strcat(caffe_model_path,'/det2.caffemodel');
RNet=caffe.Net(prototxt_dir,model_dir,'test');	
prototxt_dir = strcat(caffe_model_path,'/det3.prototxt');
model_dir = strcat(caffe_model_path,'/det3.caffemodel');
ONet=caffe.Net(prototxt_dir,model_dir,'test');
faces=cell(0);	
for i=1:length(imglist)
    %i
	img=imread(imglist{i});
	%we recommend you to set minsize as x * short side
	%minl=min([size(img,1) size(img,2)]);
	%minsize=fix(minl*0.1)
    %tic;
    [boudingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,threshold,true,factor);
    %disp(['all time:',num2str(toc),' for ',num2str(i)])
    faces{i,1}={boudingboxes};
	faces{i,2}={points'};
	%show detection result
  
        numbox=size(boudingboxes,1);
        disp(['face_num:',num2str(numbox)])
	imshow(img)
	hold on; 
	for j=1:numbox
		plot(points(1:5,j),points(6:10,j),'g.','MarkerSize',10);
		r=rectangle('Position',[boudingboxes(j,1:2) boudingboxes(j,3:4)-boudingboxes(j,1:2)],'Edgecolor','g','LineWidth',3);
    end
   hold off; 
	pause
 
end
%save result box landmark
