#!/bin/bash
para_file=para.ini
para_py=/home/staff/enze/Front_DL3/script/parameters.py
working_path=$(python2 ${para_py} -p ${para_file} working_root)
data_path=$(python2 ${para_py} -p ${para_file} data_path)
path=$1
network=$2
cd $path
if [ -f $path/batch_process.sh ] || [ -f $path/para.ini ];then
     echo "parameter file exist"
     if [ -f $path/batch_process.sh ];then
	     para=$path/batch_process.sh
     else
             para=$path/para.ini
     fi
     xmin=$(python $para_py -p $para xmin)
     xmax=$(python $para_py -p $para xmax)
     ymin=$(python $para_py -p $para ymin)
     ymax=$(python $para_py -p $para ymax)
     echo "xmin for GID$GID is $xmin"
     echo "xmax for GID$GID is $xmax"
     echo "ymin for GID$GID is $ymin"
     echo "ymax for GID$GID is $ymax"
else
     echo "no para for GID$GID"
     break
fi



dir=(`ls |grep "GID"`)
i=0
count=${#dir[@]}
while(($i<$count))
do
	cd $working_path
	temp=${network%.tar*}

	if [ -d $path/${dir[i]}/truncate_termini/$temp ];then

		if [ -d $path/${dir[i]}/truncate_figure ];then
			echo "figure exist"
		else 
			mkdir $path/${dir[i]}/truncate_figure
		fi
		if [ -d $path/${dir[i]}/truncate_figure/$temp ];then
			echo "figure/$temp exist"
			#need to remove later
			rm -r $path/${dir[i]}/truncate_figure/$temp
			mkdir mkdir $path/${dir[i]}/truncate_figure/$temp
		else
			mkdir $path/${dir[i]}/truncate_figure/$temp 
		fi
		
		
		echo "bash batch_plot_result.sh $path/${dir[i]} $path/${dir[i]}/truncate_termini/$temp  $path/${dir[i]}/truncate_figure/$temp $xmin $xmax $ymin $ymax"
		bash batch_plot_result.sh $path/${dir[i]} $path/${dir[i]}/truncate_termini/$temp  $path/${dir[i]}/truncate_figure/$temp $xmin $xmax $ymin $ymax
	else
		echo "$path/${dir[i]}/in_polygon_gmt/$temp doesn't exist"
	fi
	i=$[i+1]
done
