#!/bin/bash

path=$1
network=$2
temp=${network%.tar*}

i=$3
cd $path
for dir in `ls |grep "GID"`
do
	if [ -d $path/$dir/truncate_termini/$temp ];then

			rm $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.txt
			echo "bash batch_cal_termini_length.sh $path/$dir/truncate_termini/$temp | tee $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.txt"
			bash batch_cal_termini_length.sh $path/$dir/truncate_termini/$temp | tee $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.txt
			cp $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.txt $path/$dir/truncate_termini/${temp}_${dir}_length.txt
			echo "cat $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.txt | awk '{print $2}' > $path/$dir/truncate_termini/length.txt"
			cat $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.txt | awk '{print $2}' > $path/$dir/truncate_termini/length.txt
			echo "python /home/staff/enze/Front_DL3/data_processing/plot_hist.py --input $path/$dir/truncate_termini/length.txt --output $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.png"
			python /home/staff/enze/Front_DL3/data_processing/plot_hist.py --input $path/$dir/truncate_termini/length.txt --output $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.png
			echo "cp $path/$dir/truncate_termini/${temp}_${dir}_length.png ~/data1/Greenland_front_Mapping/data/histogram_truncatepython /home/staff/enze/Front_DL3/data_processing/plot_hist.py --input $path/$dir/truncate_termini/length.txt --output $path/$dir/truncate_termini/${temp}_${dir}_${i}_length.png"
			#cp $path/$dir/truncate_termini/${temp}_${dir}_length.png ~/data1/Greenland_front_Mapping/data/histogram_truncate
	else
		echo "no calving front"
	fi
done


