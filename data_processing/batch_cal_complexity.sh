#!/bin/bash
path=$1
code_path=/home/staff/enze/Front_DL3/data_processing/cal_average_curvature.py
cd $path
file=(`ls *.gmt`)
i=0
count=${#file[@]}
while(($i<$count))
do
	date=(`echo ${file[i]}| cut -d '.' -f 1`)
        python $code_path --input ${file[i]} --date $date
        i=$[i+1]
done
