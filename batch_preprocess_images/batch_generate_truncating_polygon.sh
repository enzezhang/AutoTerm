#!/bin/bash
para_py=/home/staff/enze/Front_DL3/script/parameters.py
path=/home/staff/enze/data1/Greenland_front_Mapping/data
cd $path
list=$path/Glacier_ID_list_temp.txt

cat $list | while read GID

do
	if [ -d $path/GID${GID} ];then
	if [ -f $path/GID${GID}/polygon/GID_${GID}_cutting_polygon.gmt ] || [ -f $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt ];then
                echo "$path/GID${GID}/polygon/GID_${GID}_cutting_polygon.gmt or $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt exist."
        else
		echo "prepare the cutting polygon of ${GID} by shrinking the ROI"

                if [ -f $path/GID${GID}/batch_process.sh ] || [ -f $path/GID${GID}/para.ini ];then
			echo "parameter file exist"
                        if [ -f $path/GID${GID}/batch_process.sh ];then
                                para=$path/GID${GID}/batch_process.sh
                        else
                                para=$path/GID${GID}/para.ini
                        fi
                        xmin=$(python $para_py -p $para xmin)
                        xmax=$(python $para_py -p $para xmax)
                        ymin=$(python $para_py -p $para ymin)
                        ymax=$(python $para_py -p $para ymax)
                        echo $xmin
			echo $xmax
                        echo $ymin
                        echo $ymax
                        dis_x=$(echo "($xmax)-($xmin)"|bc)
                        echo $dis_x
                        deduct_x=$(echo $dis_x|awk '{print $1/10}')
                        echo $deduct_x
                        xmin_shrink=$(echo "$xmin+$deduct_x"|bc)
                        xmax_shrink=$(echo "$xmax-$deduct_x"|bc)
                        echo $xmin_shrink
                        echo $xmax_shrink
                        dis_y=$(echo "($ymax)-($ymin)"|bc)
                        echo $dis_y
                        deduct_y=$(echo $dis_y|awk '{print $1/10}')
                        echo $deduct_y
                        ymin_shrink=$(echo "$ymin+$deduct_y"|bc)
                        ymax_shrink=$(echo "$ymax-$deduct_y"|bc)
                        echo $ymax_shrink

                        echo $xmin_shrink $ymin_shrink > $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt
                        echo $xmin_shrink $ymax_shrink >>$path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt
                        echo $xmax_shrink $ymax_shrink >>$path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt
                        echo $xmax_shrink $ymin_shrink >>$path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt
                        echo $xmin_shrink $ymin_shrink >>$path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt
                        echo "gmt gmt2kml -Fp $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt > $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.kml"
                        gmt gmt2kml -Fp $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.gmt > $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.kml
			ogr2ogr $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.shp $path/GID${GID}/polygon/GID_${GID}_cutting_polygon_shrink.kml
                else
                        echo "no para for GID${GID}"
                        continue

                fi
	fi
	else
		echo "GID${GID} is missing"
	fi
done
