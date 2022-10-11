#!/bin/bash

path=$1
network=$2
temp=${network%.tar*}
cd $path
for dir in `ls |grep "GID"`
do
	echo "mv $path/$dir/truncate_termini/${temp}/abandon/* $path/$dir/truncate_termini/${temp}/"
	mv $path/$dir/truncate_termini/${temp}/abandon/* $path/$dir/truncate_termini/${temp}/
	mv $path/$dir/truncate_termini/${temp}/duplicate/* $path/$dir/truncate_termini/${temp}/
	echo "mv $path/$dir/truncate_figure/${temp}/abandon/* $path/$dir/truncate_figure/${temp}/"
	mv $path/$dir/truncate_figure/${temp}/abandon/* $path/$dir/truncate_figure/${temp}/
	mv $path/$dir/truncate_figure/${temp}/duplicate/* $path/$dir/truncate_figure/${temp}/
done


