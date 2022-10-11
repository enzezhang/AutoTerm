#!/usr/bin/env bash
path=$1
network=$2

GID=$3
i=$4
temp=${network%.tar*}

data_path=$path/truncate_termini/$temp/merge_two


ref_path=$path/truncate_termini/$temp

mkdir $path/truncate_termini/${temp}_time_series


rm $path/truncate_termini/${temp}_time_series/${GID}_all.txt

bash calculate_area2.sh $data_path $ref_path | tee $path/truncate_termini/${temp}_time_series/${GID}_all.txt

cat $path/truncate_termini/${temp}_time_series/${GID}_all.txt | awk '{print $2}' > $path/truncate_termini/${temp}_time_series/area_change_${i}.txt
python /home/staff/enze/Front_DL3/data_processing/plot_hist.py --input $path/truncate_termini/${temp}_time_series/area_change_${i}.txt --output $path/truncate_termini/${temp}_time_series/area_change_${i}.png
