addpath('/home/wuwenhao/code/center_face/caffe_face/matlab');

%iii=22000;
caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(1);
%model = 'center_loss_ms.prototxt';
%weights = '99.13model.caffemodel';
%weights= '../face_example/face_snapshot/face_train_test_iter_13000.caffemodel';
%weights= '../face_example/output/scratch_casia/face_train_test_iter_30000.caffemodel';
%weights= strcat('../face_example/face_snapshot/face_train_test_iter_',num2str(iii),'.caffemodel');
model = 'center_loss_casia.prototxt';
weights = 'face_model.caffemodel';
net = caffe.Net(model, weights, 'test');

dim1=1;
% ROIx = 19:82; ROIy = 19:82;
ROIx = 1:96;
ROIy = 1:112;
feature_dim = 512;
mean_value = 128;
scale = 1/25;
%scale = 1/128;
% ROIx = 1:64;ROIy = 1:64;
height = length(ROIx);
width = length(ROIy);

allPairs = [same_pair;diff_pair];
% meanC = caffe.read_mean('D:\ThirdPartyLibrary\caffe\examples\siamese\mean.proto');

num = size(allPairs,1);
AllFeature1 = zeros(feature_dim,num);
AllFeature2 = zeros(feature_dim,num);

for i = 1 : floor(num/dim1)
    disp([i floor(num/dim1)]);
    J = zeros(height,width,3,dim1,'single');
    for j = 1 : dim1
        I = imread(allPairs{(i-1)*dim1+j,1});
        I = permute(I,[2 1 3]);
        I = I(:,:,[3 2 1]);
        I = I(ROIx,ROIy,:);
        I = single(I) - mean_value;
        J(:,:,:,j) = I*scale;
%         J(:,:,1,j) = I(end:-1:1,:);
    end;
    %tic
    f1 = net.forward({J});
    %toc
    f1 = f1{1};
    AllFeature1(1:feature_dim,(i-1)*dim1+1:i*dim1) = reshape(f1,[size(AllFeature1,1),dim1]);
%     layer_conv52 = net.blob_vec(net.name2blob_index('pool5'));
%     conv52 = layer_conv52.get_data();
%     sum(conv52(:)>0) /320/100
end;
%{
J = zeros(height,width,3,dim1,'single');
for j = 1 : num - floor(num/dim1) * dim1
    I = imread(allPairs{floor(num/dim1) * dim1+j,1});
    I = permute(I,[2 1 3]);
    I = I(:,:,[3 2 1]);
    I = I(ROIx,ROIy,:);
    I = single(I) - mean_value;
    J(:,:,:,j) = I*scale;
end;
f1 = net.forward({J});
f1=f1{1};
f1 = squeeze(f1);
AllFeature1(1:feature_dim,floor(num/dim1) * dim1+1:num) = f1(:,1 : num - floor(num/dim1) * dim1);
%}
for i = 1 : floor(num/dim1)
    disp([i floor(num/dim1)]);
    J = zeros(height,width,3,dim1,'single');
    for j = 1 : dim1
        I = imread(allPairs{(i-1)*dim1+j,2});
        I = permute(I,[2 1 3]);
        I = I(:,:,[3 2 1]);
        I = I(ROIx,ROIy,:);
        I = single(I) - mean_value;
        J(:,:,:,j) = I*scale;
    end;
    f1 = net.forward({J});
    f1 = f1{1};
    AllFeature2(1:feature_dim,(i-1)*dim1+1:i*dim1) = reshape(f1,[size(AllFeature2,1),dim1]);
end;
%{
J = zeros(height,width,3,dim1,'single');
for j = 1 : num - floor(num/dim1) * dim1
    I = imread(allPairs{floor(num/dim1) * dim1+j,2});
    I = permute(I,[2 1 3]);
    I = I(:,:,[3 2 1]);
    I = I(ROIx,ROIy,:);
    I = single(I) - mean_value;
    J(:,:,:,j) = I*scale;
end;
f1 = net.forward({J});
f1=f1{1};
f1 = squeeze(f1);
AllFeature2(1:feature_dim,floor(num/dim1) * dim1+1:num) = f1(:,1 : num - floor(num/dim1) * dim1);
%}
