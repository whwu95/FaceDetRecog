fid = fopen('match_list.txt');
same = textscan(fid,'%s %s');
same_pair = [same{1} same{2}];
fclose(fid);
fid = fopen('nomatch_list.txt');
diff= textscan(fid,'%s %s');
diff_pair = [diff{1} diff{2}];
fclose(fid);