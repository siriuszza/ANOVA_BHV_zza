#!/bin/bash

cd mean_trees

for file in ./*_mean.txt
do
    cat "$file" mean_all.txt > temp_merge.txt

    java -jar gtp.jar -v temp_merge.txt
    cut -f 3 output.txt > "${file%_mean.txt}_dis.txt"
    
    rm temp_merge.txt
done

rm output.txt

cd ../samples_tree

for file in *.txt
do
  > "../mean_trees/${file%.txt}_dis_sep.txt"
  while IFS= read -r line
  do
    (echo "$line"; cat "../mean_trees/${file%.txt}_mean.txt") > temp_merge.txt
    
    java -jar ../mean_trees/gtp.jar -v temp_merge.txt
    
    cut -f 3 output.txt >> "../mean_trees/${file%.txt}_dis_sep.txt"
    
    rm temp_merge.txt
    # let "a += 1"
  done < "$file"
done

rm output.txt