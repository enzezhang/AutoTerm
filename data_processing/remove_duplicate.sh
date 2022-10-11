#!/bin/bash

path=$1
ID=$2
cd $path
mkdir duplicate
for file in `ls *Sentinel1*_A_*.gmt`
do
        echo $file
        date=(`echo $file | cut -d '_' -f 1`)
        if [ -f ${date}_Landsat8_GID${ID}_stretch.gmt ] || [ -f ${date}_Sentinel2_GID${ID}_stretch.gmt ] || [ -f ${date}_Sentinel1_GID${ID}_D_stretch.gmt ];then
                echo "mv $file $path/duplicate"
                mv $file $path/duplicate
        fi
done


for file in `ls *Sentinel1*_D_*.gmt`
do
	echo $file
	date=(`echo $file | cut -d '_' -f 1`)
	if [ -f ${date}_Landsat8_GID${ID}_stretch.gmt ] || [ -f ${date}_Sentinel2_GID${ID}_stretch.gmt ];then
		echo "mv $file $path/duplicate"
		mv $file $path/duplicate
	fi
done
for file in `ls *Landsat8*.gmt`
do
	date=(`echo $file | cut -d '_' -f 1`)
	echo $date
	if [ -f ${date}_Sentinel2_GID${ID}_stretch.gmt ];then
		echo "mv $file $path/duplicate"
		mv $file $path/duplicate
	fi
done
