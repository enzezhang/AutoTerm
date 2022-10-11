#!/bin/bash

para_file=para.ini
para_py=/home/staff/enze/Front_DL3//script/parameters.py
working_path=$(python2 ${para_py} -p ${para_file} working_root)
data_path=$(python2 ${para_py} -p ${para_file} data_path)

if [ -d $data_path/figure_check_truncate ];then
	echo "figure check exist"
else
	mkdir $data_path/figure_check_truncate
fi


path=$1
network=$2
cd $path
dir=(`ls |grep "GID"`)
i=0
count=${#dir[@]}
while(($i<$count))
do
	cd $working_path
	temp=${network%.tar*}
	if [ -d $path/${dir[i]}/truncate_figure ];then
		echo "figure exist"
	else 
		mkdir $path/${dir[i]}/truncate_figure
	fi
	if [ -d $path/${dir[i]}/truncate_figure/$temp ];then
		echo "$path/${dir[i]}/truncate_figure/$temp exist"
		echo "cp -r $path/${dir[i]}/truncate_figure/$temp  $data_path/figure_check_truncate/${dir[i]}_$temp"
		if [ -d $data_path/figure_check_truncate/${dir[i]}_$temp ];then 
			rm -r $data_path/figure_check_truncate/${dir[i]}_$temp
			echo "already move"
			echo "cp -r $path/${dir[i]}//truncate_figure/$temp  $data_path/figure_check_truncate/${dir[i]}_$temp"
			cp -r $path/${dir[i]}//truncate_figure/$temp  $data_path/figure_check_truncate/${dir[i]}_$temp
		else
			cp -r $path/${dir[i]}//truncate_figure/$temp  $data_path/figure_check_truncate/${dir[i]}_$temp
		fi
	else
		echo "$path/${dir[i]}/truncate_figure/$temp does not exist"
	fi
	i=$[i+1]
done
