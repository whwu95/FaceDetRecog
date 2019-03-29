addpath('/home/wuwenhao/code/center_face/libsvm-master/matlab')

num = size(AllFeature1,2);
F1 = AllFeature1(1:512,:)';

F1 = bsxfun(@minus, F1, mean(F1,1));
F1 = bsxfun(@rdivide, F1, sqrt(sum(F1.^2,2)));


F2 = AllFeature2(1:512,:)';

F2 = bsxfun(@minus, F2, mean(F2,1));
F2 = bsxfun(@rdivide, F2, sqrt(sum(F2.^2,2)));


% F1 = AllFeature1';
% F2 = AllFeature2';
thresh2 = zeros(num,1);
for i = 1:num
    thresh2(i) = pdist2(F1(i,:),F2(i,:));
end;
figure;
hist(thresh2(1:3000),500);
figure;
hist(thresh2(3001:end),500);

accuracies = zeros(10,1);
for i=1:10
    test_idx = [(i-1) * 300 + 1 : i*300, (i-1) * 300 + 3001 : i*300 + 3000];
    train_idx = 1:6000;
    train_idx(test_idx) = [];
    bestc=256;
    same_label = ones(6000,1);
    same_label(3001:6000) = 0;
    cmd = [' -t 0 -h 0'];
    model = svmtrain(same_label(train_idx),thresh2(train_idx),cmd);
    [class, accuracy, deci] = svmpredict(same_label(test_idx),thresh2(test_idx),model);
    accuracies(i) = accuracy(1);
end;
mean(accuracies)
%cmd = [' -t 0 -h 0'];
%model = svmtrain(same_label,thresh2,cmd);
%[class, accuracy, deci] = svmpredict(same_label,thresh2,model);
