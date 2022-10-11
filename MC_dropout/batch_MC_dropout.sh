#!/bin/bash

path=$1
GID=$3
GID2=$4
working_path=$5
temp=$2
network=$6
#####!! need to comment out later!!!
#network=drn54_more_dropout_Jun21_2022_0.001_batch16_keep_augmentation.tar
#network=drn54_dropout0.1_Sep8_2022_0.001_batch16_keep_augmentation.tar
#network=drn54_May5_2022_0.001_batch16_keep_augmentation.tar
#####!! need to comment out later!!!

temp2=${network%.tar*}
bed_path=/home/staff/enze/data1/ice_mask/GIMP/crop_bed/buffer_15

if [ -f $path/polygon/${GID2}_cutting_polygon.gmt ];then
	polygon=$path/polygon/${GID2}_cutting_polygon.gmt
elif [ -f $path/polygon/${GID2}_cutting_polygon_shrink.gmt ];then
	polygon=$path/polygon/${GID2}_cutting_polygon_shrink.gmt

else
        echo "no cutting polygon for $GID"
        continue
fi


cd $path 
dir=(`ls | grep "GID"`)
i=0
count=${#dir[@]}
while(($i<$count))
do


	#create dir for MCdropout
	if [ -d $path/${dir[i]}/MC_dropout ];then
		echo "$path/${dir[i]}/MC_dropout exist"
	else
	        mkdir $path/${dir[i]}/MC_dropout
	fi
	if [ -d $path/${dir[i]}/MC_dropout/$temp2 ];then
		rm -r $path/${dir[i]}/MC_dropout/$temp2
		mkdir $path/${dir[i]}/MC_dropout/$temp2
	        echo "$path/${dir[i]}/MC_dropout/$temp2 exist"
	else
		echo "$path/${dir[i]}/MC_dropout/$temp2"
	        mkdir $path/${dir[i]}/MC_dropout/$temp2
	fi


	if [ -d $path/truncate_termini/$temp ];then
		cd $path/truncate_termini/$temp 

		#####MC_dropout for Landsat-8
		rm $working_path/list/MC_dropout.txt
		if [ ${dir[i]} = ${GID2}_Landsat-8 ];then

			echo "MC dropout for Landsat8"
			for file in `ls *Landsat8*.gmt | shuf -n 10` 
			do
				nametemp=(`echo $file| cut -d '.' -f 1`)
				find $path/${dir[i]}/upsample/$nametemp.tif >>$working_path/list/MC_dropout.txt
			done
		elif [ ${dir[i]} = ${GID2}_Sentinel-2 ];then
			echo "MC dropout for Sentinel2"
			for file in `ls *Sentinel2*.gmt | shuf -n 10` 
			do
				nametemp=(`echo $file| cut -d '.' -f 1`)
				find $path/${dir[i]}/upsample/$nametemp.tif >>$working_path/list/MC_dropout.txt
			done
		elif [[ ${dir[i]} = ${GID2}_Sentinel-1_A ]]; then
			echo "MC dropout for Sentinel1A"
			for file in `ls *Sentinel1*A*.gmt | shuf -n 10` 
			do
				nametemp=(`echo $file| cut -d '.' -f 1`)
				find $path/${dir[i]}/upsample/$nametemp.tif >>$working_path/list/MC_dropout.txt
			done
		elif [[ ${dir[i]} = ${GID2}_Sentinel-1_D ]]; then
			echo "MC dropout for Sentinel1D"
			for file in `ls *Sentinel1*D*.gmt | shuf -n 10` 
			do
				nametemp=(`echo $file| cut -d '.' -f 1`)
				find $path/${dir[i]}/upsample/$nametemp.tif >>$working_path/list/MC_dropout.txt
			done
		fi
		
		for j in {1..3}
		do	
			cd $working_path
			echo "bash exe_inference_MC_dropout.sh $polygon $network"
			bash exe_inference_MC_dropout.sh $polygon $network 
			if [ -d $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j} ];then
				echo "$path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j} exist"
			else
				mkdir $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}
			fi

			if [ -d $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/in_polygon_gmt/ ];then
				rm -r $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/in_polygon_gmt/ 
	                        echo "$path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/in_polygon_gmt/ exist"
	                fi
			cp -r in_polygon_gmt $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/

			if [ -d $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/post_output/ ];then
				rm -r $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/post_output/
	                        echo "$path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/post_output/ exist"
	                fi
			cp -r  post_output  $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/

			###truncate termini
			if [ -d $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini ];then 
				rm -r $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini
				mkdir $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini
				echo "$path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini exist"
			else
				mkdir $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini
			fi
			
			cd $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/in_polygon_gmt/
			for file in `ls *.gmt`
			do
				if [ -f $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$file ];then
					echo "$path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$file exist"
				else
					echo "python /home/staff/enze/Front_DL3/data_processing/truncate_termini.py --input $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/in_polygon_gmt/$file --bed $bed_path/bed_GID${GID}_\?\?.gmt --output $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$file"
					python /home/staff/enze/Front_DL3/data_processing/truncate_termini.py --input $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/in_polygon_gmt/$file --bed $bed_path/bed_${GID}_\?\?.gmt --output $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$file
					gmt gmtset FORMAT_GEO_OUT=ddd.xxx
					name_temp=(`echo $file | cut -d '.' -f 1`)
					gmt gmt2kml -Fl $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$file > $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$name_temp.kml 
					ogr2ogr $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$name_temp.shp $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/$name_temp.kml

				fi
			done
			

			#plot truncate
			if [ -d $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_figure ];then
				rm -r $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_figure
				mkdir $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_figure
				echo "$path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_figure exist"
			else
				mkdir $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_figure
			fi
			echo "bash $working_path/batch_plot_truncate_MC_dropout.sh $path $path/${dir[i]} $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/ $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_figure"
			bash $working_path/batch_plot_truncate_MC_dropout.sh $path $path/${dir[i]} $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini/ $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_figure



		done


	else
		echo "error! no $path/truncate_termini/$temp"
	fi
	i=$[i+1]
done

