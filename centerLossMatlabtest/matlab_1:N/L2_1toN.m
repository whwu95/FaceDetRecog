
%load('model&feature/99.13_MS-Celeb-1M/lfw_feature.mat');
%load('casia_feature_0_10.mat');
%load('casia_list.mat');
%AllFeature = casia_feature_0_10;
listUsed = list(1:20);
num = size(listUsed,1);
label = zeros(num,1);
predict_label = zeros(num,1);
distance = zeros(num,1);
pair_dis = zeros(num,1); 
thresh = 1;


F1 = AllFeature(1:512,1:num)';
F1 = bsxfun(@minus, F1, mean(F1,1));
F1 = bsxfun(@rdivide, F1, sqrt(sum(F1.^2,2)));


for j = 1:num
   disp([j num]);  
   tic  
   F2 = repmat(F1(j,:),num,1);
   distance = sqrt(sum((F1-F2).^2,2));   
   distance(j) = inf;
   [V,I] = min(distance);
   pair_dis(j) = pdist2(F1(j,:),F1(I,:));
   s1=regexp(listUsed(j),'/','split');
   s2=regexp(listUsed(I),'/','split');   
   if strcmp(s1{1}{7},s2{1}{7})
       label(j)=1;
   end
   toc
end

%save 99.13_L2_data
true_num = 0;
for k = 1:num
    if pair_dis(k)< thresh
        predict_label(k) = 1;
    else predict_label(k) = 0;
    end
    if label(k) == predict_label(k)
        true = true + 1;
    end
end

accuracy = true/num;


   
