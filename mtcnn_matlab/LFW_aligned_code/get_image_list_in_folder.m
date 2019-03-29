function [ image_list ] = get_image_list_in_folder( folder )

    root_list = dir(folder);
    root_list = root_list(3:end);
    image_list = {};
    for i=1:length(root_list)
        if root_list(i).isdir
            sub_list = get_image_list_in_folder(fullfile(folder,root_list(i).name));
            image_list = [image_list;sub_list];
         else
            [~, ~, c] = fileparts(root_list(i).name);
            if strcmp(c,'.png') == 0 && strcmp(c,'.jpg') == 0 && strcmp(c,'.bmp') == 0 && strcmp(c,'.jpeg') == 0 ...
                && strcmp(c,'.PNG') == 0 && strcmp(c,'.JPG') == 0 && strcmp(c,'.BMP') == 0 && strcmp(c,'.JPEG') == 0
                continue;
            end;
            image_list = [image_list;fullfile(folder,root_list(i).name)];          
        end;      
    end;
end

