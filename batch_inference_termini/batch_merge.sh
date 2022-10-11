#!/bin/bash
path=$1
network=$2
temp=${network%.tar*}
work_dir=$path/truncate_termini/$temp
script=merge_two_calving2.sh

rm $work_dir/*.invert

if [ -d $work_dir/merge_two ];then
        echo "merge two exist"
	rm -r $work_dir/merge_two
	mkdir $work_dir/merge_two
else
        mkdir $work_dir/merge_two
fi
echo "bash $script $work_dir $work_dir/merge_two"
bash $script $work_dir $work_dir/merge_two
