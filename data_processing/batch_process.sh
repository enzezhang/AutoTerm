#!/bin/bash
path=/home/staff/enze/data1/Greenland_front_Mapping/data/
GID=GID$1
GID2=GID_$1
xmin=$2
ymin=$3
xmax=$4
ymax=$5
x_size_L=$6
y_size_L=$7
x_size_S=$8
y_size_S=$9

echo "bash batch_process_Landsat-8_images.sh $path/$GID/${GID2}_Landsat-8 $xmin $ymin $xmax $ymax $x_size_L $y_size_L Landsat8_${GID}"
echo "bash batch_process_Sentinel-2_images.sh $path/$GID/${GID2}_Sentinel-2 $xmin $ymin $xmax $ymax $x_size_S $y_size_S Sentinel2_${GID}"
echo "bash batch_process_Sentinel-1_images.sh $path/$GID/${GID2}_Sentinel-1_D $xmin $ymin $xmax $ymax $x_size_S $y_size_S Sentinel1_${GID}_D"
echo "bash batch_process_Sentinel-1_images.sh $path/$GID/${GID2}_Sentinel-1_A $xmin $ymin $xmax $ymax $x_size_S $y_size_S Sentinel1_${GID}_A"
echo "bash batch_stretch.sh $path/$GID/${GID2}_Landsat-8/after_merge $path/$GID/${GID2}_Landsat-8/hist_eq"
echo "bash batch_stretch.sh $path/$GID/${GID2}_Sentinel-2/after_merge $path/$GID/${GID2}_Sentinel-2/hist_eq"
echo "bash batch_stretch.sh $path/$GID/${GID2}_Sentinel-2_D/after_merge $path/$GID/${GID2}_Sentinel-2_D/hist_eq"
echo "bash batch_stretch.sh $path/$GID/${GID2}_Sentinel-2_A/after_merge $path/$GID/${GID2}_Sentinel-2_A/hist_eq"

bash batch_process_Landsat-8_images.sh $path/$GID/${GID2}_Landsat-8 $xmin $ymin $xmax $ymax $x_size_L $y_size_L Landsat8_${GID}
bash batch_process_Sentinel-2_images.sh $path/$GID/${GID2}_Sentinel-2 $xmin $ymin $xmax $ymax $x_size_S $y_size_S Sentinel2_${GID}
bash batch_process_Sentinel-1_images.sh $path/$GID/${GID2}_Sentinel-1_D $xmin $ymin $xmax $ymax $x_size_S $y_size_S Sentinel1_${GID}_D
bash batch_process_Sentinel-1_images.sh $path/$GID/${GID2}_Sentinel-1_A $xmin $ymin $xmax $ymax $x_size_S $y_size_S Sentinel1_${GID}_A
bash batch_stretch.sh $path/$GID/${GID2}_Landsat-8/after_merge $path/$GID/${GID2}_Landsat-8/hist_eq
bash batch_stretch.sh $path/$GID/${GID2}_Sentinel-2/after_merge $path/$GID/${GID2}_Sentinel-2/hist_eq
bash batch_stretch.sh $path/$GID/${GID2}_Sentinel-1_D/after_merge $path/$GID/${GID2}_Sentinel-1_D/hist_eq
bash batch_stretch.sh $path/$GID/${GID2}_Sentinel-1_A/after_merge $path/$GID/${GID2}_Sentinel-1_A/hist_eq
