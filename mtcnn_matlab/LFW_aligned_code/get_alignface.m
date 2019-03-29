%get image_list:the dir of all images
folder = '/media/sdb0/wuwenhao/data/lfw';
image_list = get_image_list_in_folder(folder);
target_folder = 'lfw_matlab_align';


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

%param
factor=0.709;
minsize = 50;
coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
                51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
imgSize = [112, 96];

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

for image_id = 1:length(image_list);
    img = imread([image_list{image_id}]);
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
    [boundingboxes points]=detect_face(img,min([minsize size(img,1) size(img,2)]),PNet,RNet,ONet,threshold,false,factor);
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
    Tfm =  cp2tform(facial5points', coord5points', 'similarity');
    cropImg = imtransform(img, Tfm, 'XData', [1 imgSize(2)],'YData', [1 imgSize(1)], 'Size', imgSize);
    imwrite(cropImg, target_filename);
end;
