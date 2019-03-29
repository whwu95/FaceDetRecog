%get image_list:the dir of all images
folder = 'org';
image_list = get_image_list_in_folder(folder);
target_folder = 'matlab_detect';

if exist(target_folder, 'dir')==0
    mkdir(target_folder);
end;


%path of toolbox
caffe_path='caffe/matlab';
pdollar_toolbox_path='toolbox-master';
caffe_model_path='model';
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

%caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();	
caffe.set_device(gpu_id);
caffe.reset_all();
%three steps's threshold
threshold=[0.6 0.7 0.7];

%scale factor
factor=0.709;
%minimum size of face
minsize=50;


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
	img=imread(image_list{image_id});
    if size(img, 3) < 3
       img(:,:,2) = img(:,:,1);
       img(:,:,3) = img(:,:,1);
    end
    [file_folder, file_name, file_ext] = fileparts(image_list{image_id});
    target_filename = strrep(image_list{image_id},folder, target_folder);
    assert(strcmp(target_filename, image_list{image_id})==0);
    [file_folder, file_name, file_ext] = fileparts(target_filename);
    if exist(file_folder,'dir')==0
        mkdir(file_folder);
    end;
    disp([num2str(image_id) '/' num2str(length(image_list)) ' ' target_filename]);
    
    
    [boundingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,threshold,false,factor);
    if isempty(boundingboxes)
        continue;
    end;
    
    faces{image_id,1}={boundingboxes};
	faces{image_id,2}={points'};
	%show detection result
  
    numbox=size(boundingboxes,1);
    disp(['face_num:',num2str(numbox)])
	%imshow(img)
	%hold on; 
	for j=1:numbox
		%plot(points(1:5,j),points(6:10,j),'g.','MarkerSize',10);
		%r=rectangle('Position',[boundingboxes(j,1:2) boundingboxes(j,3:4)-boundingboxes(j,1:2)],'Edgecolor','g','LineWidth',3);      
    end
     img_crop=imcrop(img,[boundingboxes(j,1),boundingboxes(j,2),boundingboxes(j,3)-boundingboxes(j,1),boundingboxes(j,4)-boundingboxes(j,2)]);
     imwrite(img_crop,target_filename);
    %hold off; 
	%pause
 
end
%save result box landmark
