#!/usr/bin/env bash
path=$1
network=$2

GID=$3
temp=${network%.tar*}

echo "bash split_data_by_name.sh $path/truncate_termini/${temp}_time_series/${GID}_all.txt $path/truncate_termini/${temp} $GID $temp $path/truncate_termini/${temp}_time_series/"
bash split_data_by_name.sh $path/truncate_termini/${temp}_time_series/${GID}_all.txt $path/truncate_termini/${temp} $GID $temp $path/truncate_termini/${temp}_time_series/

echo "bash split_data_by_name.sh $path/truncate_termini/${temp}_time_series/accu/${GID}_all.txt $path/truncate_termini/${temp} $GID $temp $path/truncate_termini/${temp}_time_series/accu"
bash split_data_by_name.sh $path/truncate_termini/${temp}_time_series/accu/${GID}_all.txt $path/truncate_termini/${temp} $GID $temp $path/truncate_termini/${temp}_time_series/accu


