#!/usr/bin/env bash
path=$1
network=$2
script=/home/staff/enze/Front_DL3/data_processing/calculate_abs_area.py
GID=$3
temp=${network%.tar*}
cd $path/truncate_termini/${temp}/duplicate
rm -r merge_two 
mkdir merge_two
rm Landsat-8_error.txt
#rm Sentinel-1_A_error.txt
#rm Sentinel-1_D_error.txt
#for file in `ls *Sentinel1*_A_*.gmt`
#do
#	date=(`echo $file|cut -d '_' -f 1`)
#	if [ `ls -A $path/truncate_termini/${temp}/${date}*.gmt.invert` ];then
#
#		other=(`ls $path/truncate_termini/${temp}/${date}*.gmt.invert`)
#		satellite=(`echo ${other[0]}|cut -d '_' -f 2`)
#		if [ "$satellite" == "Sentinel1" ];then
#			continue
#			echo "the duplicate file is ${other[0]}"
#		else
#			cat ${other[0]} $file > $path/truncate_termini/${temp}/merge_two/$file
#			python $script --input $path/truncate_termini/${temp}/merge_two/$file --reference ${other[0]} --date $date >> Sentinel-1_A_error.txt
#		fi
#	else
#		echo "no file for $file"
#	fi
#done
#
#
#for file in `ls *Sentinel1*_D_*.gmt`
#do
#        date=(`echo $file|cut -d '_' -f 1`)
#        if [ `ls -A $path/truncate_termini/${temp}/${date}*.gmt.invert` ];then
#
#                other=(`ls $path/truncate_termini/${temp}/${date}*.gmt.invert`)
#                satellite=(`echo ${other[0]}|cut -d '_' -f 2`)
#                if [ "$satellite" == "Sentinel1" ];then
#                        continue
#                        echo "the duplicate file is ${other[0]}"
#                else
#                        cat ${other[0]} $file > $path/truncate_termini/${temp}/merge_two/$file
#                        python $script --input $path/truncate_termini/${temp}/merge_two/$file --reference ${other[0]} --date $date >> Sentinel-1_D_error.txt
#                fi
#        else
#                echo "no file for $file"
#        fi
#done
#
for file in `ls *Landsat8*.gmt`
do
	date=(`echo $file|cut -d '_' -f 1`)
	if [ `ls -A $path/truncate_termini/${temp}/${date}*.gmt.invert` ];then

                other=(`ls $path/truncate_termini/${temp}/${date}*.gmt.invert`)
                satellite=(`echo ${other[0]}|cut -d '_' -f 2`)
                if [ "$satellite" == "Sentinel1" ];then
                        continue
                        echo "the duplicate file is ${other[0]}"
                else
                        cat ${other[0]} $file > $path/truncate_termini/${temp}/duplicate/merge_two/$file
                        python $script --input $path/truncate_termini/${temp}/duplicate/merge_two/$file --reference ${other[0]} --date $date >> Landsat-8_error.txt
                fi
	else
		echo "no file for $file"
	fi
done


