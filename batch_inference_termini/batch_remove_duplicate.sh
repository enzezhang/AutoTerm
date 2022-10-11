#!/bin/bash
path=$1
network=$2
ID=$3
temp=${network%.tar*}
work_dir=$path/truncate_termini/$temp
script=remove_duplicate.sh
if [ -d $work_dir/duplicate ];then
        echo "duplicate exist"
else
        mkdir $work_dir/duplicate
fi
bash $script $work_dir $ID
