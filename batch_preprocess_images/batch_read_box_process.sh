#!/bin/bash
para_py=/home/staff/enze/Front_DL3/script/parameters.py
path=/home/staff/enze/data1/Greenland_front_Mapping/data
cd $path

list=Glacier_ID_list_temp.txt
cat $list | while read GID

do
	if [ -d $path/GID$GID ];then

		if [ -f $path/GID$GID/batch_process.sh ] || [ -f $path/GID$GID/para.ini ];then
			echo "parameter file exist"

		else
			read xmin ymin xmax ymax <<<$(python $path/get_roi.py --id $GID)
			echo $xmin $ymin $xmax $ymax
			echo $GID
			echo "GID=GID$GID" >> $path/GID$GID/para.ini
			echo "GID2=GID_$GID">>$path/GID$GID/para.ini
			echo "xmin=$xmin" >>$path/GID$GID/para.ini
			echo "ymin=$ymin" >>$path/GID$GID/para.ini
			echo "xmax=$xmax" >>$path/GID$GID/para.ini
			echo "ymax=$ymax" >>$path/GID$GID/para.ini

			if [ -d $path/GID$GID/GID_${GID}_Landsat-8 ] && [ "`ls -A $path/GID$GID/GID_${GID}_Landsat-8/original_image/`" ] ;then

				L_image=(`find $path/GID$GID/GID_${GID}_Landsat-8/original_image/*.tif | head -n 1`)
				echo $L_image
				read x_size_L y_size_L <<<$(python $path/get_imagesize.py --image $L_image)
				echo $x_size_L $y_size_L
				echo "x_size_L=$x_size_L">>$path/GID$GID/para.ini
				echo "y_size_L=$y_size_L">>$path/GID$GID/para.ini
			else
				echo "GID_${GID}_Landsat-8 is missing or $path/GID$GID/GID_${GID}_Landsat-8/original_image/ is empty" 
				continue
			fi
			if [ -d $path/GID$GID/GID_${GID}_Sentinel-2 ];then
				S_image=(`find $path/GID$GID/GID_${GID}_Sentinel-2/original_image/*.tif | head -n 1`)
				echo $S_image
				read x_size_S y_size_S <<<$(python $path/get_imagesize.py --image $S_image)
				echo $x_size_S $y_size_S
				echo "x_size_S=$x_size_S">>$path/GID$GID/para.ini
                        	echo "y_size_S=$y_size_S">>$path/GID$GID/para.ini
				#echo "bash batch_process.sh $GID $xmin $ymin $xmax $ymax $x_size_L $y_size_L $x_size_S $y_size_S"
				#bash batch_process.sh $GID $xmin $ymin $xmax $ymax $x_size_L $y_size_L $x_size_S $y_size_S
			else
				echo "GID_${GID}_Sentinel-2 is missing"
				continue
			fi
		fi
		if [ -f $path/GID${GID}/batch_process.sh ] || [ -f $path/GID${GID}/para.ini ];then
                        echo "parameter file exist"
                        if [ -f $path/GID${GID}/batch_process.sh ];then
                                para=$path/GID${GID}/batch_process.sh
                        else
                                para=$path/GID${GID}/para.ini
                        fi
                        xmin=$(python $para_py -p $para xmin)
                        ymin=$(python $para_py -p $para ymin)
                        xmax=$(python $para_py -p $para xmax)
                        ymax=$(python $para_py -p $para ymax)
                        x_size_L=$(python $para_py -p $para x_size_L)
                        y_size_L=$(python $para_py -p $para y_size_L)
                        x_size_S=$(python $para_py -p $para x_size_S)
                        y_size_S=$(python $para_py -p $para y_size_S)
			echo "bash batch_process.sh $GID $xmin $ymin $xmax $ymax $x_size_L $y_size_L $x_size_S $y_size_S"
                        bash batch_process.sh $GID $xmin $ymin $xmax $ymax $x_size_L $y_size_L $x_size_S $y_size_S
                else
                        echo "no para for $GID"
                fi


	else
		echo "$path/GID$GID is missing"
	fi
done
