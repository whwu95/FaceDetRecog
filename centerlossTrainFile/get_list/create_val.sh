rm val.txt
touch val.txt
cat cleaned_aligned_real_label.txt | shuf -n90000>>val.txt
echo 'Done..'
