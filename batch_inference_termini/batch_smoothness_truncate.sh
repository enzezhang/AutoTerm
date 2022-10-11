#!/bin/bash

path=$1
network=$2
temp=${network%.tar*}
i=$3
cd $path
for dir in `ls |grep "GID"`
do
	if [ -d $path/$dir/truncate_termini/$temp ];then

			echo "bash batch_cal_complexity.sh $path/$dir/truncate_termini/$temp | tee $path/$dir/truncate_termini/${temp}_${dir}.txt"
			rm $path/$dir/truncate_termini/${temp}_${dir}.txt
			bash batch_cal_complexity.sh $path/$dir/truncate_termini/$temp | tee $path/$dir/truncate_termini/${temp}_${dir}_${i}_smoothness.txt
			cp $path/$dir/truncate_termini/${temp}_${dir}_${i}_smoothness.txt $path/$dir/truncate_termini/${temp}_${dir}_smoothness.txt
			echo "cat $path/$dir/truncate_termini/${temp}_${dir}.txt | awk '{print \$2}' > $path/$dir/truncate_termini/temp.txt"
			cat $path/$dir/truncate_termini/${temp}_${dir}_${i}_smoothness.txt | awk '{print $2}' > $path/$dir/truncate_termini/smoothness.txt
			echo "python /home/staff/enze/Front_DL3/data_processing/plot_hist.py --input $path/$dir/truncate_termini/smoothness.txt --output $path/$dir/truncate_termini/${temp}_${dir}_${i}.png"
			python /home/staff/enze/Front_DL3/data_processing/plot_hist.py --input $path/$dir/truncate_termini/smoothness.txt --output $path/$dir/truncate_termini/${temp}_${dir}_${i}.png
			#echo "cp $path/$dir/truncate_termini/${temp}_${dir}.png ~/data1/Greenland_front_Mapping/data/histogram_truncate"
			#cp $path/$dir/truncate_termini/${temp}_${dir}.png ~/data1/Greenland_front_Mapping/data/histogram_truncate
	else
		echo "no calving front"
	fi
done


