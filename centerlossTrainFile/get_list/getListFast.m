%requirement : classnd.txt (dataset's name and label from 0),here is casia
%requirement : a dataset 
%output : list with label

folder = '/home/wuwenhao/code/backup/GetAlign/code/casia_align';



%image_list = get_image_list_in_folder(folder);

file='label.txt';
fid=fopen(file,'w');

num = length(image_list);
currentLabel = -1;
temp = [];

for i = 1:num
    
    if mod(i, 1000) == 0
        disp(num2str(i));
    end
    
    s=regexp(image_list{i},'/','split');
    str = s{9};
        
    if ~strcmp(str, temp)
        temp = str;
        currentLabel = currentLabel+1;
    end
        
    labelStr = num2str(currentLabel);
    fprintf(fid,'%s %d\n',image_list{i}, currentLabel);
    
end
fclose(fid);


