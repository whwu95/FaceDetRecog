%requirement : classnd.txt (dataset's name and label from 0),here is casia
%requirement : a dataset 
%output : list with label

folder = '/home/wuwenhao/code/backup/GetAlign/code/casia_align';

%get folder classnd.txt
%{
root_list = dir(folder);
root_list = root_list(3:end);
file='classnd.txt';
fid=fopen(file,'w')
for i=1:length(root_list)
  fprintf(fid,'%s %d\n',root_list(i).name,i-1);
end
fclose(fid);
%}

% fid1 = fopen('list/classnd.txt');
% label = textscan(fid1,'%s %d\n');
image_list = get_image_list_in_folder(folder);
file='label.txt';
fid=fopen(file,'w');
num = length(image_list);

temp = [];
currentLabel = -1;

for i = 1:num
    
    s=regexp(image_list{i},'/','split');
    str = s{9};
    
    if ~strcmp(str, temp)
        currentLabel = currentLabel+1;
    end
        
    labelStr = num2str(currentLabel);
    fprintf(fid,'%s %d\n',image_list{i},currentLabel);
    
end
