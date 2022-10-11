#!/bin/bash


para_file=para.ini
para_py=/home/staff/enze/Front_DL3/script/parameters.py
working_path=$(python2 ${para_py} -p ${para_file} working_root)
path=$1
polygon=$2
network=$3
cd $path
dir=(`ls |grep "GID"`)
i=0
count=${#dir[@]}
while(($i<$count))
do
	cd $working_path

	if [ "`ls -A $path/${dir[i]}/upsample`" = "" ];then
		echo "no $path/${dir[i]}/upsample"
		if [ "`ls -A $path/${dir[i]}/hist_eq`" = "" ];then
			echo "$path/${dir[i]}/hist_eq is empty"
		else
			echo "bash preparing_influence.sh $path/${dir[i]}/hist_eq"
			bash preparing_influence.sh $path/${dir[i]}/hist_eq
		fi
	else
		echo "bash preparing_influence.sh $path/${dir[i]}/upsample"
		bash preparing_influence.sh $path/${dir[i]}/upsample
		
	fi


	if [ -f $working_path/list/test.txt ];then
		echo "succeed"
	else
		echo "error! no test.txt"
		exit
	fi
	echo "bash exe_inference.sh $polygon $network"
	bash exe_inference.sh $polygon $network
	rm $working_path/list/test.txt
	if [ -d $path/${dir[i]}/in_polygon_gmt ];then
		echo "in_polygon_gmt exist"
	else
		mkdir $path/${dir[i]}/in_polygon_gmt
	fi
	if [ -d $path/${dir[i]}/post_process_shape ];then
                echo "post_process_shape exist"
        else
                mkdir $path/${dir[i]}/post_process_shape
        fi
	temp=${network%.tar*}

	if [ -d $path/${dir[i]}/in_polygon_gmt/$temp ];then
		echo "$path/${dir[i]}/in_polygon_gmt/$temp exist"
		rm -r $path/${dir[i]}/in_polygon_gmt/$temp
	else
		echo "$path/${dir[i]}/in_polygon_gmt/$temp don't exist"
	fi

	if [ -d $path/${dir[i]}/post_process_shape/$temp ];then
                echo "$path/${dir[i]}/post_process_shape/$temp exist"
                rm -r $path/${dir[i]}/post_process_shape/$temp
        else
                echo "$path/${dir[i]}/post_process_shape/$temp don't exist"
        fi

	echo "mv post_process_shape $path/${dir[i]}/post_process_shape/$temp"
	mv post_process_shape $path/${dir[i]}/post_process_shape/$temp
	echo "mv in_polygon_gmt $path/${dir[i]}/in_polygon_gmt/$temp"
	mv in_polygon_gmt $path/${dir[i]}/in_polygon_gmt/$temp

	i=$[i+1]
done
