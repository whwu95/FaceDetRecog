num = size(AllFeature1,2);
F1 = AllFeature1(:,:)';
 %F1 = bsxfun(@minus, F1, mean(F1,1));
F1 = bsxfun(@rdivide, F1, sqrt(sum(F1.^2,2)));

F2 = AllFeature2(:,:)';
 %F2 = bsxfun(@minus, F2, mean(F2,1));
F2 = bsxfun(@rdivide, F2, sqrt(sum(F2.^2,2)));

L2 = zeros(num,1);
for i = 1:num
    L2(i) = pdist2(F1(i,:),F2(i,:));
end;

%figure;
%hist(L2(1:3000),500);
%figure;
%hist(L2(3001:end),500);

accuracies = zeros(10,1);
best_threshold = 0.7;
best_accu = -1;

for threshold = 2:-0.001:0
    k = fix((2 -threshold)/0.005 +1);
    for i=1:10
        test_idx = [(i-1) * 300 + 1 : i*300, (i-1) * 300 + 3001 : i*300 + 3000];
        same_label = ones(6000,1);
        same_label(3001:6000) = 0;
        samePredicTruetNum = sum(L2(test_idx(1:300))<threshold);
        diffPredicTruetNum = sum(L2(test_idx(301:600))>threshold);
        FPR = (300 - diffPredicTruetNum)/300;
        TPR = samePredicTruetNum/300;
        accuracy = (samePredicTruetNum + diffPredicTruetNum)/600;
        TPRs(i) = TPR;
        FPRs(i) = FPR;
        accuracies(i) = accuracy;
    end;  
    accu = mean(accuracies);
    acc(k) = mean(accuracies);
    TPR_value(k) = mean(TPRs);
    FPR_value(k) = mean(FPRs);
    disp(['threshold: ',num2str(threshold),' accuracy: ',num2str(accu)]);
    if accu > best_accu
        best_accu = accu;
        best_threshold = threshold;
    end
end
disp(['best threshold: ',num2str(best_threshold),' best accuracy: ',num2str(best_accu)])
plot(FPR_value,TPR_value)
