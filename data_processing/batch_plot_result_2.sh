#!/bin/bash 
path=$1
image_path=$path/hist_eq
script_path=result_plot.sh
calving_path=$2
out_path=$3
xmin=$4
xmax=$5
ymin=$6
ymax=$7
cd $calving_path
calving_file=(`ls *.gmt`)


count=${#calving_file[@]}

i=0
#cd /home/zez/test_deep_learning/u_net/figure
while(($i<$count))
do	
	echo $i/$count
	temp=(`echo ${calving_file[i]}| cut -d '.' -f 1`)
	echo $temp
	date=${temp:0:8}
	
	echo "bash $script_path $image_path/$temp.tif $calving_path/$temp.gmt $date $out_path/$temp.ps $xmin $xmax $ymin $ymax"
	if [ -f $out_path/$temp.jpg ];then
		echo "$out_path/$temp.jpg exist"
	else
		bash $script_path $image_path/$temp.tif $calving_path/$temp.gmt $date $out_path/$temp.ps $xmin $xmax $ymin $ymax
		#bash $script_path $image_path/$temp2.tif $calving_path/$temp.gmt $date $out_path/$temp.ps $xmin $xmax $ymin $ymax
	fi
	i=$[i+1]
done
	
	

