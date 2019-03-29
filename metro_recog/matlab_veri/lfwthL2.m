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


best_threshold = 0.7;
best_accu = -1;

for threshold = 0:0.01:2
    samePredicTruetNum = sum(L2(1:(num/2))<threshold);
    diffPredicTruetNum = sum(L2((num/2+1):num)>threshold);
    recall = samePredicTruetNum/(num/2);
    noise = 1-diffPredicTruetNum/(num/2);
    accuracy = (samePredicTruetNum + diffPredicTruetNum) /num;
    %accuracy = recall;
    %accuracy = diffPredicTruetNum/(num/2);
    
    disp(['threshold: ',num2str(threshold),' accuracy: ',num2str(accuracy)]);
    
    if accuracy > best_accu
        best_accu = accuracy;
        best_threshold = threshold;
    end
end
disp(['best threshold: ',num2str(best_threshold),' best accuracy: ',num2str(best_accu)])

%plot(FPR_value,TPR_value)
