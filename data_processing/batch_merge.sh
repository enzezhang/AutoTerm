#!/bin/bash
work_dir=$1
script=/home/staff/enze/Front_DL3/data_processing/merge_two_calving2.sh
if [ -d $work_dir/merge_two ];then
        echo "merge two exist"
else
        mkdir $work_dir/merge_two
fi
echo "bash $script $work_dir $work_dir/merge_two"
bash $script $work_dir $work_dir/merge_two
