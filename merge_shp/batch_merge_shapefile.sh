#!/bin/bash
work_path=/home/staff/enze/data1/Greenland_front_Mapping/data/final_results
uncertainty_file=$work_path/uncertainty_all_lola.txt
output=$work_path/merge_shp
path=$1
cd $path
for file in `ls *.shp`
do
	date=(`echo $file | cut -d '_' -f 1`)
	satellite=(`echo $file | cut -d '_' -f 2`)
	GID=(`echo $file | cut -d '_' -f 3`)
	GID2=${GID#*GID}
	uncertainty=(`python $work_path/get_uncertainty.py --uncertainty $uncertainty_file --satellite $satellite --GID $GID2`)
	echo $uncertainty
	echo ""python $work_path/merge_shapefile.py --input_shape $file --output_shape $output/${GID}.shp --date $date --GID $GID --satellite $satellite --uncertainty $uncertainty
	python $work_path/merge_shapefile.py --input_shape $file --output_shape $output/${GID}.shp --date $date --GID $GID --satellite $satellite --uncertainty $uncertainty
done
