#!/usr/bin/env bash
path=$1
network=$2

GID=$3
temp=${network%.tar*}

script2=/home/staff/enze/Front_DL3/data_processing/find_offset.py
script3=/home/staff/enze/Front_DL3/data_processing/calculate_error.py


echo "bash plot_time_series.sh $path/truncate_termini/${temp}_time_series/ $GID $path/truncate_termini/${temp}_time_series/${GID}_${temp}_time_series.ps"
cd $path/truncate_termini/${temp}/duplicate

#if [ -f Sentinel-1_A_offset.txt ];then
#
#        offset_s1a=(`python $script2 --input Sentinel-1_A_offset.txt`)
#	offset_s1a=(`echo $offset_s1a | awk 'function abs(v) {return v < 0 ? -v : v} {printf("%.5f\n",abs($1))}'`)
#else
#        offset_s1a=0
#fi
#if [ -f Sentinel-1_D_offset.txt ];then
#
#        offset_s1d=(`python $script2 --input Sentinel-1_D_offset.txt`)
#	offset_s1d=(`echo $offset_s1d | awk 'function abs(v) {return v < 0 ? -v : v} {printf("%.5f\n",abs($1))}'`)
#else
#        offset_s1d=0
#fi
#
#
#
#if [ -f Sentinel-1_A_error.txt ];then
#        error_s1a=(`python $script3 --input Sentinel-1_A_error.txt`)
#        echo "Sentinel-1A error is $error_s1a"
#        error_s1a=$(echo "($error_s1a)-($offset_s1a)"|bc)
#	echo "Sentinel-1A error is $error_s1a"
#else
#	echo "ERROR!!! no uncertainty for $GID Sentinel-1_A"
#	error_s1a=0.01
#fi
#
#if [ -f Sentinel-1_D_error.txt ];then
#        error_s1d=(`python $script3 --input Sentinel-1_D_error.txt`)
#        echo "Sentinel-1D error is $error_s1d"
#        error_s1d=$(echo "($error_s1d)-($offset_s1d)"|bc)
#	echo "Sentinel-1D error is $error_s1d"
#else
#	echo "ERROR!!! no uncertainty for $GID Sentinel-1_D"
#        error_s1d=0.01
#fi
#

if [ -f Landsat-8_error.txt ];then
       error_l8=(`python $script3 --input Landsat-8_error.txt`)
else
	echo "ERROR!!! no uncertainty for $GID Landsat-8"
	error_l8=0.0
fi


#bash plot_time_series.sh $path/truncate_termini/${temp}_time_series/ $GID $path/truncate_termini/${temp}_time_series/${GID}_${temp}_time_series.ps
echo "bash plot_time_series.sh $path/truncate_termini/${temp}_time_series/accu $GID $path/truncate_termini/${temp}_time_series/${GID}_${temp}_time_series_accu.ps $error_l8 "

bash plot_time_series.sh $path/truncate_termini/${temp}_time_series/accu $GID $path/truncate_termini/${temp}_time_series/${GID}_${temp}_time_series_accu.ps $error_l8 

#cp $path/truncate_termini/${temp}_time_series/${GID}_${temp}_time_series.png /home/staff/enze/data1/Greenland_front_Mapping/data/figure_time_series
cp $path/truncate_termini/${temp}_time_series/${GID}_${temp}_time_series_accu.png /home/staff/enze/data1/Greenland_front_Mapping/data/figure_time_series

