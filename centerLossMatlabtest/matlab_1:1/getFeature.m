addpath('../caffe_face/matlab');


caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(1);
model = 'deploy_center_loss_casia.prototxt';
weights = '98.55model.caffemodel';
%model = 'face_deploy.prototxt';
%weights = 'face_model.caffemodel';
net = caffe.Net(model, weights, 'test');


% ROIx = 19:82; ROIy = 19:82;
ROIx = 1:96;
ROIy = 1:112;
feature_dim = 512;
mean_value = 128;
scale = 1/128;%1/25 1/128

% ROIx = 1:64;ROIy = 1:64;
height = length(ROIx);
width = length(ROIy);

allPairs = [same_pair;diff_pair];
% meanC = caffe.read_mean('D:\ThirdPartyLibrary\caffe\examples\siamese\mean.proto');

num = size(allPairs,1);
AllFeature1 = zeros(feature_dim,num);
AllFeature2 = zeros(feature_dim,num);

for i = 1 : num
    disp([i num]);
    tic;
    J = zeros(height,width,3,1,'single');
    I = imread(allPairs{i,1});
    I = permute(I,[2 1 3]);
    I = I(:,:,[3 2 1]);
    I = I(ROIx,ROIy,:);
    I = single(I) - mean_value;
    J(:,:,:,1) = I*scale;
%         J(:,:,1,j) = I(end:-1:1,:);
    f1 = net.forward({J});
    f1 = f1{1};
    toc
    AllFeature1(1:feature_dim,i) = reshape(f1,[size(AllFeature1,1),1]);
end;



for i = 1 : num
    disp([i num]);
    J = zeros(height,width,3,1,'single');
        I = imread(allPairs{i,2});
        I = permute(I,[2 1 3]);
        I = I(:,:,[3 2 1]);
        I = I(ROIx,ROIy,:);
        I = single(I) - mean_value;
        J(:,:,:,1) = I*scale;
    f1 = net.forward({J});
    f1 = f1{1};
    AllFeature2(1:feature_dim,i) = reshape(f1,[size(AllFeature2,1),1]);
end;