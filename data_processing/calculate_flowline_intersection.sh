#!/usr/bin/env bash


data_path=$1

script=/home/staff/enze/Front_DL3/data_processing/calculate_flowline_intersection.py
flowline=$2

cd $data_path
file=(`ls *.gmt`)

count=${#file[@]}
i=0
while(($i<$count))
do
    temp=${file[i]:0:8}

        python $script --input ${file[i]} --flowline $flowline --date $temp
    i=$[i+1]
done
