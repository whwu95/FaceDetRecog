clear;
%list of images
target_folder='./target/';
image_list=importdata('imglist.txt');
if exist(target_folder, 'dir')==0
    mkdir(target_folder);
end;
%minimum size of face
minsize=50;

%path of toolbox
caffe_path='/home/wuwenhao/code/center_face/MTCNN/caffe/matlab';
pdollar_toolbox_path='/home/wuwenhao/code/center_face/MTCNN/caffe/matlab/toolbox-master';
caffe_model_path='../../v1model';
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
                51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
imgSize = [112, 96];


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
	
for image_id=1:length(image_list)
    img = imread(image_list{image_id});
    if size(img, 3) < 3
       img(:,:,2) = img(:,:,1);
       img(:,:,3) = img(:,:,1);
    end 
    target_filename = [target_folder,image_list{image_id}];
    tic;
    [boundingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,threshold,false,factor);
    disp(['all time:',num2str(toc),' for ',num2str(image_id)])
    if isempty(boundingboxes)
        continue;
    end;
    default_face = 1;
    if size(boundingboxes,1) > 1
        for bb=2:size(boundingboxes,1)
            if abs((boundingboxes(bb,1) + boundingboxes(bb,3))/2 - size(img,2) / 2) + abs((boundingboxes(bb,2) + boundingboxes(bb,4))/2 - size(img,1) / 2) < ...
                    abs((boundingboxes(default_face,1) + boundingboxes(default_face,3))/2 - size(img,2) / 2) + abs((boundingboxes(default_face,2) + boundingboxes(default_face,4))/2 - size(img,1) / 2)
                default_face = bb;
            end;
        end;
    end;
  
    facial5points = double(reshape(points(:,default_face),[5 2])');
    

        Tfm =  cp2tform(facial5points', coord5points', 'affine');
        cropImg = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
                                      'YData', [1 imgSize(1)], 'Size', imgSize);

    imwrite(cropImg, target_filename);
end;
