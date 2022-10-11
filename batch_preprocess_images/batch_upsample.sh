#!/bin/bash
para_py=/home/staff/enze/Front_DL3/script/parameters.py
path=/home/staff/enze/data1/Greenland_front_Mapping/data
cd $path
list=$path/Glacier_ID_list_all.txt

cat $list | while read GID

do
	if [ -d $path/GID${GID} ];then
		if [ -f $path/GID${GID}/batch_process.sh ] || [ -f $path/GID${GID}/para.ini ];then
                        echo "parameter file exist"
                        if [ -f $path/GID${GID}/batch_process.sh ];then
                                para=$path/GID${GID}/batch_process.sh
                        else
                                para=$path/GID${GID}/para.ini
                        fi
			x_size_L=$(python $para_py -p $para x_size_L)
			y_size_L=$(python $para_py -p $para y_size_L)
			x_size_S=$(python $para_py -p $para x_size_S)
			y_size_S=$(python $para_py -p $para y_size_S)
			if [ $x_size_L -lt 1000 ];then
				echo  $x_size_L
				factor_x_L=$((1000/$x_size_L+1))
				echo "factor_x_L is $factor_x_L"
				new_size_x_L=`expr $x_size_L \* $factor_x_L`
				new_size_y_L=`expr $y_size_L \* $factor_x_L`
				echo "$new_size_x_L $new_size_y_L"

				mkdir $path/GID${GID}/GID_${GID}_Landsat-8/upsample
				cd $path/GID${GID}/GID_${GID}_Landsat-8/hist_eq
				for images in `ls *.tif`
				do
					if [ -f $path/GID${GID}/GID_${GID}_Landsat-8/upsample/$images ];then
						echo "$images exist"
					else
						echo "gdalwarp -r cubic -ts $new_size_x_L $new_size_y_L $images $path/GID${GID}/GID_${GID}_Landsat-8/upsample/$images"
						gdalwarp -r cubic -ts $new_size_x_L $new_size_y_L $images $path/GID${GID}/GID_${GID}_Landsat-8/upsample/$images
					fi
				done
                                
				echo  $x_size_S
                                factor_S=$((1000/$x_size_S+1))
                                echo "factor_x_S is $factor_S"
				new_size_x_S=`expr $x_size_S \* $factor_S`
				new_size_y_S=`expr $y_size_S \* $factor_S`
				echo "$new_size_x_S $new_size_y_S"
				if [ -d $path/GID${GID}/GID_${GID}_Sentinel-1_A/ ];then
				mkdir $path/GID${GID}/GID_${GID}_Sentinel-1_A/upsample
				#rm $path/GID${GID}/GID_${GID}_Sentinel-1_A/upsample/*
				cd $path/GID${GID}/GID_${GID}_Sentinel-1_A/hist_eq
				for image in `ls *tif`
				do
                                        if [ -f $path/GID${GID}/GID_${GID}_Sentinel-1_A/upsample/$image ];then
                                                echo "$image exist"
                                        else
                                                echo "gdalwarp -r cubic -ts $new_size_x_S $new_size_y_S $image $path/GID${GID}/GID_${GID}_Sentinel-1_A/upsample/$image"
                                                gdalwarp -r cubic -ts $new_size_x_S $new_size_y_S $image $path/GID${GID}/GID_${GID}_Sentinel-1_A/upsample/$image
                                        fi
                                done
				fi
				if [ -d $path/GID${GID}/GID_${GID}_Sentinel-1_D/ ];then
				mkdir $path/GID${GID}/GID_${GID}_Sentinel-1_D/upsample
				#rm $path/GID${GID}/GID_${GID}_Sentinel-1_D/upsample/*
                                cd $path/GID${GID}/GID_${GID}_Sentinel-1_D/hist_eq
                                for image in `ls *tif`
                                do
                                        if [ -f $path/GID${GID}/GID_${GID}_Sentinel-1_D/upsample/$image ];then
                                                echo "$image exist"
                                        else
                                                echo "gdalwarp -r cubic -ts $new_size_x_S $new_size_y_S $image $path/GID${GID}/GID_${GID}_Sentinel-1_D/upsample/$image"
                                                gdalwarp -r cubic -ts $new_size_x_S $new_size_y_S $image $path/GID${GID}/GID_${GID}_Sentinel-1_D/upsample/$image
                                        fi
                                done
				fi


				mkdir $path/GID${GID}/GID_${GID}_Sentinel-2/upsample
				#rm $path/GID${GID}/GID_${GID}_Sentinel-2/upsample/*
                                cd $path/GID${GID}/GID_${GID}_Sentinel-2/hist_eq
                                for image in `ls *tif`
                                do
                                        if [ -f $path/GID${GID}/GID_${GID}_Sentinel-2/upsample/$image ];then
                                                echo "$image exist"
                                        else
                                                echo "gdalwarp -r cubic -ts $new_size_x_S $new_size_y_S $image $path/GID${GID}/GID_${GID}_Sentinel-2/upsample/$image"
                                                gdalwarp -r cubic -ts $new_size_x_S $new_size_y_S $image $path/GID${GID}/GID_${GID}_Sentinel-2/upsample/$image
                                        fi
                                done
			else
				echo "no need to upsample for $GID"
				echo "ln -s $path/GID${GID}/GID_${GID}_Landsat-8/hist_eq $path/GID${GID}/GID_${GID}_Landsat-8/upsample"
				ln -s $path/GID${GID}/GID_${GID}_Landsat-8/hist_eq $path/GID${GID}/GID_${GID}_Landsat-8/upsample
				ln -s $path/GID${GID}/GID_${GID}_Sentinel-1_A/hist_eq $path/GID${GID}/GID_${GID}_Sentinel-1_A/upsample
				ln -s $path/GID${GID}/GID_${GID}_Sentinel-1_D/hist_eq $path/GID${GID}/GID_${GID}_Sentinel-1_D/upsample
				ln -s $path/GID${GID}/GID_${GID}_Sentinel-2/hist_eq $path/GID${GID}/GID_${GID}_Sentinel-2/upsample


                        fi

		else
			echo "no para for $GID"
		fi
	else
		echo "no GID$GID folder"
	fi
done

