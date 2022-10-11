#!/usr/bin/env bash


data_path=$1
#output=$2

script=/home/staff/enze/Front_DL3/data_processing/calculate_area.py
ref_path=$2

cd $ref_path
ref=(`ls *.gmt`)
cd $data_path
file=(`ls *.gmt`)

count=${#file[@]}
#rm $output
i=0
while(($i<$count))
do
    temp=${file[i]:0:8}

        python $script --input ${file[i]} --reference $ref_path/${file[i]} --date $temp
    i=$[i+1]
done
