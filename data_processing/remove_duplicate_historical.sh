#!/bin/bash

path=$1
ID=$2
cd $path
mkdir duplicate
for file in `ls *Landsat7*.gmt`
do
	date=(`echo $file | cut -d '_' -f 1`)
	echo $date
	if [ -f ${date}_Landsat5_GID${ID}_stretch.gmt ];then
		echo "mv $file $path/duplicate"
		mv $file $path/duplicate
	fi
done
