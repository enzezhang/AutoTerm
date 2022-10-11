#!/bin/bash

path=$1
GID=$3
temp2=$4
temp=$2
script1=/home/staff/enze/Front_DL3/data_processing/calculate_abs_area.py
script2=/home/staff/enze/Front_DL3/data_processing/invert_data2.py
mkdir $path/MC_dropout
cd $path 
dir=(`ls | grep "GID"`)
i=0
count=${#dir[@]}
while(($i<$count))
do
	rm $path/MC_dropout/MC_uncertainty_${dir[i]}.txt
	if [ -d $path/${dir[i]}/MC_dropout/$temp2/ ];then
		echo "$path/${dir[i]}/MC_dropout/$temp exist"
		for j in {1..3}
                do
			if [ -d $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini ];then
				echo " $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j} exist"
				mkdir $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/merge_two
				cd $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/truncate_termini
				for file in `ls *.gmt`
				do
					date=${file:0:8}
					if [ -f $path/truncate_termini/$temp/$file ];then
						echo " python $script2 --input ${file} --output ${file}.invert"
						python $script2 --input ${file} --output ${file}.invert
						echo "cat ${file}.invert $path/truncate_termini/$temp/$file > $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/merge_two/$file"
						cat ${file}.invert $path/truncate_termini/$temp/$file > $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/merge_two/$file
						echo "python $script1 --input $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/merge_two/$file --reference $file --date $date"
						python $script1 --input $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}/merge_two/$file --reference $file --date $date >> $path/MC_dropout/MC_uncertainty_${dir[i]}.txt
					else
						echo "no result for $file"
					fi
				done

			else
				echo "ERROR no $path/${dir[i]}/MC_dropout/$temp2/MC_dropout_${j}"
				break
			fi
		done

	else
		echo "no $path/${dir[i]}/MC_dropout/$temp, move to the next glacier"
		continue
	fi
	i=$[i+1]
done
