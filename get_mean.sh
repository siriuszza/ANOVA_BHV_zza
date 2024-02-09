#!/bin/bash

mkdir mean_trees

cd samples_tree

> all_tree

for trees in *.txt
do
	java -jar SturmMean.jar -e 0.0001 -u $trees |
		tail -n 1 > ../mean_trees/${trees%.txt}_mean.txt
	cat $trees >> all_tree
done

java -jar SturmMean.jar -e 0.0001 -u all_tree |
                tail -n 1 > ../mean_trees/mean_all.txt

rm output.txt