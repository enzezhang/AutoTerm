#!/bin/bash

path=/home/staff/enze/data1/Greenland_front_Mapping/data
cd $path

#list=/home/staff/enze/data1/TermPicks_V1/script/Glacier_new_ID_list_label_figure.txt
list=Glacier_ID_list_temp.txt
cat $list | while read GID

do
	if [ -d $path/GID$GID ];then
		cd $path/GID$GID
		for dir in `ls |grep "GID"`
		do
			echo $dir
		if [ -d $path/GID$GID/$dir/hist_eq ];then
			mkdir $path/GID$GID/$dir/hist_eq/abandon
			for file in `ls $path/GID$GID/$dir/hist_eq/*.tif`
			do
				flag=(`python /home/staff/enze/data1/Greenland_front_Mapping/data/remove_partial_images.py --input $file`)
				echo $flag
				if [ $flag == 'remove' ];then
					echo "mv $file $path/GID$GID/$dir/hist_eq/abandon"
					mv $file $path/GID$GID/$dir/hist_eq/abandon
				else	
					echo "$file is a whole image"
				fi
			done
		else
			echo "$GID $dir/hist_eq is missing"
		fi
		done
	else
		echo "$path/GID$GID is missing"
	fi
done
