%load('lfw_list.mat');
%load('model&feature/98.9_30000_CASIA/lfw_feature')
fid = fopen('pairs.txt');
CC = fscanf(fid,'%d %d');
n_set = CC(1);n_num=CC(2);

same_pair = cell(n_set*n_num,2);
diff_pair = cell(n_set*n_num,2);
lfw_label = zeros(n_set*n_num * 2,2);

for i=1:n_set
    for j = 1 : n_num
        CC = textscan(fid,'%s %d %d\r\n');
        p = CC{1};id1=CC{2};id2=CC{3};
        same_pair((i-1)*n_num + j,1) = {sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p{1},p{1},id1)};
        same_pair((i-1)*n_num + j,2) = {sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p{1},p{1},id2)};
        if exist('list','var')
            lfw_label((i-1)*n_num + j,1) = find(strcmp(list, sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p{1},p{1},id1)));
            lfw_label((i-1)*n_num + j,2) = find(strcmp(list, sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p{1},p{1},id2)));
        end;
    end;
    for j = 1 : n_num
        CC = textscan(fid, '%s %d %s %d\r\n');
        p1 = CC{1};id1=CC{2};p2=CC{3};id2=CC{4};
        diff_pair((i-1)*n_num + j,1) = {sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p1{1},p1{1},id1)};
        diff_pair((i-1)*n_num + j,2) = {sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p2{1},p2{1},id2)};
        if exist('list','var')
            lfw_label(n_set*n_num + (i-1)*n_num + j,1) = find(strcmp(list, sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p1{1},p1{1},id1)));
            lfw_label(n_set*n_num + (i-1)*n_num + j,2) = find(strcmp(list, sprintf('/media/sdb0/wuwenhao/data/lfw_aligned_matlab/%s/%s_%04d.jpg',p2{1},p2{1},id2)));
        end;
    end;
end;
fclose(fid);

if exist('AllFeature','var')
    AllFeature1 = AllFeature(:,lfw_label(:,1));
    AllFeature2 = AllFeature(:,lfw_label(:,2));
end;
