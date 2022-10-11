#!/bin/bash
path=/home/staff/enze/data1/Greenland_front_Mapping/data/historical
GID=GID$1
GID2=GID_$1
xmin=$2
ymin=$3
xmax=$4
ymax=$5
x_size_L5=$6
y_size_L5=$7
x_size_L7=$8
y_size_L7=$9


bash batch_process_Landsat-8_images.sh $path/$GID/${GID2}_Landsat-5 $xmin $ymin $xmax $ymax $x_size_L5 $y_size_L5 Landsat5_${GID}
bash batch_process_Landsat-8_images.sh $path/$GID/${GID2}_Landsat-7 $xmin $ymin $xmax $ymax $x_size_L7 $y_size_L7 Landsat7_${GID}
bash batch_stretch.sh $path/$GID/${GID2}_Landsat-5/after_merge $path/$GID/${GID2}_Landsat-5/hist_eq
bash batch_stretch.sh $path/$GID/${GID2}_Landsat-7/after_merge $path/$GID/${GID2}_Landsat-7/hist_eq
