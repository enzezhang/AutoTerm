#!/bin/bash

path=$1
network=$2
GID=$3
bed_path=/home/staff/enze/data1/ice_mask/GIMP/crop_bed/buffer_15
temp=${network%.tar*}
cd $path
for dir in `ls |grep "GID"`
do
	if [ -d $path/$dir/in_polygon_gmt/$temp ];then
		if [ -d $path/$dir/truncate_termini ];then
			echo "$path/$dir/truncate_termini exist"
		else
			mkdir $path/$dir/truncate_termini
		fi
		if [ -d $path/$dir/truncate_termini/$temp ];then
			echo "$path/$dir/truncate_termini/$temp exist"
			echo "rm -r $path/$dir/truncate_termini/$temp"
			rm -r $path/$dir/truncate_termini/$temp
			mkdir $path/$dir/truncate_termini/$temp
		else
			mkdir $path/$dir/truncate_termini/$temp
		fi
		
		cd $path/$dir/in_polygon_gmt/$temp	
		for file in `ls *.gmt`
		do
			if [ -f $path/$dir/truncate_termini/$temp/$file ];then
				echo "$path/$dir/truncate_termini/$temp/$file exist"
			else
				echo "python /home/staff/enze/Front_DL3/data_processing/truncate_termini.py --input $path/$dir/in_polygon_gmt/$temp/$file --bed $bed_path/bed_GID${GID}_\?\?.gmt --output $path/$dir/truncate_termini/$temp/$file"
				python /home/staff/enze/Front_DL3/data_processing/truncate_termini.py --input $path/$dir/in_polygon_gmt/$temp/$file --bed $bed_path/bed_GID${GID}_\?\?.gmt --output $path/$dir/truncate_termini/$temp/$file
			fi
		done
	else
		echo "no calving front"
	fi
done


