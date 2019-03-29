addpath('/home/wuwenhao/code/center_face/caffe_face/matlab');
load('casia_list.mat');
caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(3);
weights= 'model&feature/99.13_MS-Celeb-1M/99.20model.caffemodel';
model = 'model&feature/99.13_MS-Celeb-1M/center_loss_ms.prototxt';
net = caffe.Net(model, weights, 'test');

ROIx = 1:96;
ROIy = 1:112;
feature_dim = 512;
mean_value = 128;
scale = 1/25;
height = length(ROIx);
width = length(ROIy);
num =20;%num = size(list,1);
AllFeature = zeros(feature_dim,num);

for i = 1 : num
    disp([i num]);
    tic;
    J = zeros(height,width,3,1,'single');
    I = imread(list{i,1});
    I = permute(I,[2 1 3]);
    I = I(:,:,[3 2 1]);
    I = I(ROIx,ROIy,:);
    I = single(I) - mean_value;
    J(:,:,:,1) = I*scale;
    f1 = net.forward({J});
    f1 = f1{1};
    toc
    AllFeature(1:feature_dim,i) = reshape(f1,[size(AllFeature,1),1]);
end;
save casia_feature AllFeature
