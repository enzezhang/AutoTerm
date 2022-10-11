#!/bin/bash
path=$1
network=$2
temp=${network%.tar*}
echo $temp
cd $path
for dir in `ls |grep "GID"`
do
	GID=(`echo $dir | cut -d '_' -f 2`)
	satellite=(`echo $dir | cut -d '_' -f 3`)
	echo $path/$dir/truncate_termini/${temp}_GID_${GID}_Landsat-8.txt
	### remove based on turning points
	if [ -f $path/$dir/truncate_termini/${temp}_${dir}_smoothness.txt ];then
		mkdir $path/$dir/truncate_termini/${temp}/abandon
		mkdir $path/$dir/truncate_figure/${temp}/abandon
		mkdir $path/$dir/hist_eq/abandon_result_based
		#cat $path/GID_${GID}_Landsat-8/truncate_termini/${temp}_GID_${GID}_Landsat-8_smoothness.txt | awk '{print $2}' > $path/$dir/truncate_termini/smoothness1.txt
		#cat $path/GID_${GID}_Sentinel-2/truncate_termini/${temp}_GID_${GID}_Sentinel-2_smoothness.txt  | awk '{print $2}' > $path/$dir/truncate_termini/smoothness2.txt
		if [ $satellite == Sentinel-1 ];then
			echo "For Sentinel-1, use the threshold for Sentinel-2"
			echo "cat $path/GID_${GID}_Sentinel-2/truncate_termini/${temp}_GID_${GID}_Sentinel-2_smoothness.txt"
			cat $path/GID_${GID}_Sentinel-2/truncate_termini/${temp}_GID_${GID}_Sentinel-2_smoothness.txt  | awk '{print $2}' > $path/$dir/truncate_termini/smoothness.txt
		else
			cat $path/$dir/truncate_termini/${temp}_${dir}_smoothness.txt | awk '{print $2}' > $path/$dir/truncate_termini/smoothness.txt
		fi
		threshold=(`python /home/staff/enze/Front_DL3/data_processing/cal_threshold.py --input $path/$dir/truncate_termini/smoothness.txt`)
		#threshold1=(`python /home/staff/enze/Front_DL3/data_processing/cal_threshold.py --input $path/$dir/truncate_termini/smoothness1.txt`)
		#threshold2=(`python /home/staff/enze/Front_DL3/data_processing/cal_threshold.py --input $path/$dir/truncate_termini/smoothness2.txt`)
		#threshold=(`echo $threshold1 $threshold2| awk '{sum=$1+$2}END{print sum/2}'`)
		#mv $path/$dir/truncate_termini/${temp}/abandon/*.gmt $path/$dir/truncate_termini/${temp}/abandon/
	        #mv $path/$dir/truncate_figure/${temp}/abandon/*.jpg $path/$dir/truncate_figure/${temp}/ 	
		echo "threshold for ${temp}_${dir}.txt is $threshold"
		cat $path/$dir/truncate_termini/${temp}_${dir}_smoothness.txt | while read line
		do
			name=(`echo $line| awk '{print $1}'`)
			smoothness=(`echo $line| awk '{print $2}'`)
			if [ `echo "$smoothness > $threshold"|bc` -eq 1 ];then
				echo $line	
				echo "mv $path/$dir/truncate_termini/${temp}/$name.gmt $path/$dir/truncate_termini/${temp}/abandon"	
				mv $path/$dir/truncate_termini/${temp}/$name.gmt $path/$dir/truncate_termini/${temp}/abandon
				echo "mv $path/$dir/truncate_figure/${temp}/$name.jpg $path/$dir/truncate_figure/${temp}/abandon"
				mv $path/$dir/truncate_figure/${temp}/$name.jpg $path/$dir/truncate_figure/${temp}/abandon
			fi
		done
	else
		echo "no smoothness for GID$GID"
	fi


	####remove based on length
	if [ -f $path/$dir/truncate_termini/${temp}_${dir}_length.txt ];then
		#cat $path/GID_${GID}_Landsat-8/truncate_termini/${temp}_GID_${GID}_Landsat-8_length.txt |awk '{print $2}' > $path/$dir/truncate_termini/length1.txt
		#cat $path/GID_${GID}_Sentinel-2/truncate_termini/${temp}_GID_${GID}_Sentinel-2_length.txt |awk '{print $2}' > $path/$dir/truncate_termini/length2.txt
                if [ $satellite == Sentinel-1 ];then
			echo "For Sentinel-1 use the threshold for Sentinel-2"
			echo "$path/GID_${GID}_Sentinel-2/truncate_termini/${temp}_GID_${GID}_Sentinel-2_length.txt"
			cat $path/GID_${GID}_Sentinel-2/truncate_termini/${temp}_GID_${GID}_Sentinel-2_length.txt | awk '{print $2}' > $path/$dir/truncate_termini/length.txt 
		else

			cat $path/$dir/truncate_termini/${temp}_${dir}_length.txt |awk '{print $2}' > $path/$dir/truncate_termini/length.txt
		fi
                #read threshold_l_max1 threshold_l_min1 <<< $(python /home/staff/enze/Front_DL3/data_processing/cal_threshold_2.py --input $path/$dir/truncate_termini/length1.txt)
		#read threshold_l_max2 threshold_l_min2 <<< $(python /home/staff/enze/Front_DL3/data_processing/cal_threshold_2.py --input $path/$dir/truncate_termini/length2.txt)
		read threshold_l_max threshold_l_min <<< $(python /home/staff/enze/Front_DL3/data_processing/cal_threshold_2.py --input $path/$dir/truncate_termini/length.txt)
		#threshold_l_max=(`echo $threshold_l_max1 $threshold_l_max2 | awk '{sum=$1+$2}END{print sum/2}'`)
		#threshold_l_min=(`echo $threshold_l_min1 $threshold_l_min2 | awk '{sum=$1+$2}END{print sum/2}'`)
                echo "threshold for ${temp}_${dir}_length.txt are $threshold_l_min $threshold_l_max"
                cat $path/$dir/truncate_termini/${temp}_${dir}_length.txt | while read line
                do
                        name=(`echo $line| awk '{print $1}'`)
                        length=(`echo $line| awk '{print $2}'`)
                        if [[ `echo "$length > $threshold_l_max"|bc` -eq 1 || `echo "$length < $threshold_l_min"|bc` -eq 1 ]];then        
				echo $line

                                        echo "mv $path/$dir/truncate_termini/${temp}/$name.gmt $path/$dir/truncate_termini/${temp}/abandon"
                                        mv $path/$dir/truncate_termini/${temp}/$name.gmt $path/$dir/truncate_termini/${temp}/abandon
                                        echo "mv $path/$dir/truncate_figure/${temp}/$name.jpg $path/$dir/truncate_figure/${temp}/abandon"
                                        mv $path/$dir/truncate_figure/${temp}/$name.jpg $path/$dir/truncate_figure/${temp}/abandon

                        fi
                done
        else
                echo "no smoothness for ${temp}_${dir}"
        fi
done


