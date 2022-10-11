#!/bin/bash
path=$1
network=$2
GID=$3
temp=${network%.tar*}
GID2=${GID#*GID}
if [ -d $path/truncate_termini/${temp}/abandon ];then
	cd $path/truncate_termini/${temp}/abandon
	for file in `ls *.gmt`
	do
		
		date=(`echo $file | cut -d '_' -f 1`)
		temp2=(`echo $file | cut -d '.' -f 1`)
		if [ "${file}" = ${date}_Landsat8_${GID}_stretch.gmt ];then
			echo "mv $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/abandon"
			echo "mv $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/abandon"
			mv $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/abandon
			mv $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/abandon
		elif [ "${file}" = ${date}_Sentinel2_${GID}_stretch.gmt ];then
			echo "mv $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/abandon"
			echo "mv $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/abandon"
			mv $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/abandon
			mv $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/abandon
        	elif [ "${file}" = ${date}_Sentinel1_${GID}_A_stretch.gmt ];then
			echo "mv $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/abandon"
			echo "mv $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/abandon"
			mv $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/abandon
			mv $path/GID_${GID2}_Sentinel-1_A/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-1_A/truncate_figure/$temp/abandon

        	elif [ "${file}" = ${date}_Sentinel1_${GID}_D_stretch.gmt ];then
			echo "mv $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/abandon"
			echo "mv $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/abandon"
			mv $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/abandon
			mv $path/GID_${GID2}_Sentinel-1_D/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-1_D/truncate_figure/$temp/abandon
        	else
                	echo "error"
                	sleep 5
        	fi
	done
fi


if [ -d $path/truncate_termini/${temp}/duplicate ];then
	mkdir $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/duplicate
	mkdir $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/duplicate
	mkdir $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/duplicate
	mkdir $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/duplicate
	mkdir $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/duplicate
        mkdir $path/GID_${GID2}_Sentinel-1_A/truncate_figure/$temp/duplicate
        mkdir $path/GID_${GID2}_Sentinel-1_D/truncate_figure/$temp/duplicate
        mkdir $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/duplicate
	cd $path/truncate_termini/${temp}/duplicate
	for file in `ls *.gmt`
		do
                date=(`echo $file | cut -d '_' -f 1`)
                temp2=(`echo $file | cut -d '.' -f 1`)
                if [ "${file}" = ${date}_Landsat8_${GID}_stretch.gmt ];then
                        echo "mv $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/duplicate"
			mv $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Landsat-8/truncate_termini/$temp/duplicate
			echo "mv $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/duplicate"
			mv $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Landsat-8/truncate_figure/$temp/duplicate
                elif [ "${file}" = ${date}_Sentinel2_${GID}_stretch.gmt ];then
                        echo "mv $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/duplicate"
			mv $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-2/truncate_termini/$temp/duplicate
			echo "mv $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/duplicate"
			mv $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-2/truncate_figure/$temp/duplicate
                elif [ "${file}" = ${date}_Sentinel1_${GID}_A_stretch.gmt ];then
                        echo "mv $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/duplicate"
			mv $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_A/truncate_termini/$temp/duplicate
			echo "mv $path/GID_${GID2}_Sentinel-1_A/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-1_A/truncate_figure/$temp/duplicate"
			mv $path/GID_${GID2}_Sentinel-1_A/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-1_A/truncate_figure/$temp/duplicate
                elif [ "${file}" = ${date}_Sentinel1_${GID}_D_stretch.gmt ];then
                        echo "mv $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/duplicate"
			mv $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/$temp2.gmt $path/GID_${GID2}_Sentinel-1_D/truncate_termini/$temp/duplicate
			echo "mv $path/GID_${GID2}_Sentinel-1_D/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-1_D/truncate_figure/$temp/duplicate"
			mv $path/GID_${GID2}_Sentinel-1_D/truncate_figure/$temp/$temp2.jpg $path/GID_${GID2}_Sentinel-1_D/truncate_figure/$temp/duplicate
                else
                        echo "error"
                        sleep 5
                fi
        done
fi
