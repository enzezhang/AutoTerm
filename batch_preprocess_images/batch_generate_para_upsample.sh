#!/bin/bash

path=/home/staff/enze/data1/Greenland_front_Mapping/data
cd $path
filename=para_upsample.ini
list=Glacier_ID_list_temp.txt
cat $list | while read GID

do
	if [ -d $path/GID$GID ];then
		rm $path/GID$GID/$filename

		if [ -f $path/GID$GID/$filename ];then
			echo "parameter file exist"

		else

			if [ -d $path/GID$GID/GID_${GID}_Landsat-8 ] && [ "`ls -A $path/GID$GID/GID_${GID}_Landsat-8/upsample/`" ] ;then

				L_image=(`find $path/GID$GID/GID_${GID}_Landsat-8/upsample/*.tif | head -n 1`)
				echo $L_image
				echo "python $path/get_roi.py --id $GID"
                        	read xmin ymin xmax ymax <<<$(python $path/get_roi.py --id $GID)
                        	echo $xmin $ymin $xmax $ymax
                        	echo $GID
				echo "GID=GID$GID" >> $path/GID$GID/$filename
                        	echo "GID2=GID_$GID">>$path/GID$GID/$filename
                        	echo "xmin=$xmin" >>$path/GID$GID/$filename
                        	echo "ymin=$ymin" >>$path/GID$GID/$filename
                        	echo "xmax=$xmax" >>$path/GID$GID/$filename
                        	echo "ymax=$ymax" >>$path/GID$GID/$filename
				read x_size_L y_size_L <<<$(python $path/get_imagesize.py --image $L_image)
				echo $x_size_L $y_size_L
				echo "x_size_L=$x_size_L">>$path/GID$GID/$filename
				echo "y_size_L=$y_size_L">>$path/GID$GID/$filename
			else
				echo "GID_${GID}_Landsat-8 is missing or $path/GID$GID/GID_${GID}_Landsat-8/upsample/ is empty" 
				continue
			fi
			if [ -d $path/GID$GID/GID_${GID}_Sentinel-2 ] && [ "`ls -A $path/GID$GID/GID_${GID}_Sentinel-2/upsample/`" ];then
				S_image=(`find $path/GID$GID/GID_${GID}_Sentinel-2/upsample/*.tif | head -n 1`)
				echo $S_image
				read x_size_S y_size_S <<<$(python $path/get_imagesize.py --image $S_image)
				echo $x_size_S $y_size_S
				echo "x_size_S=$x_size_S">>$path/GID$GID/$filename
                        	echo "y_size_S=$y_size_S">>$path/GID$GID/$filename
			else
				echo "GID_${GID}_Sentinel-2 is missing or $path/GID$GID/GID_${GID}_Sentinel-2/upsample/ is empty "
				continue
			fi
		fi
	else
		echo "$path/GID$GID is missing"
	fi
done
