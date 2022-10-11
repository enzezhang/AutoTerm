#!/bin/bash
path=$1
network=$2
temp=${network%.tar*}
cd $path
for dir in `ls |grep "GID"`
do
	### remove empty results
	mkdir $path/$dir/truncate_termini/${temp}/abandon
	mkdir $path/$dir/truncate_figure/${temp}/abandon
	cd $path/$dir/truncate_termini/${temp}
	for file in `ls *.gmt`
	do
		count=(`wc -l $file | awk '{print $1}'`)
		if [ $count -gt 3 ];then
			echo "$file is not empty"
		else
			name=(`echo $file| cut -d '.' -f 1`)
			echo "mv $path/$dir/truncate_termini/${temp}/$file $path/$dir/truncate_termini/${temp}/abandon"
			mv $path/$dir/truncate_termini/${temp}/$file $path/$dir/truncate_termini/${temp}/abandon
			echo "mv $path/$dir/truncate_figure/${temp}/$name.jpg $path/$dir/truncate_figure/${temp}/abandon"
			mv $path/$dir/truncate_figure/${temp}/$name.jpg $path/$dir/truncate_figure/${temp}/abandon
		fi
	done
	cd $path/$dir/truncate_figure/${temp}
	for file in `ls *.jpg`
	do
		name=(`echo $file| cut -d '.' -f 1`)
		if [ -f $path/$dir/truncate_termini/${temp}/$name.gmt ];then
			echo "$file exist"
		else
			echo "mv $path/$dir/truncate_figure/${temp}/$file $path/$dir/truncate_figure/${temp}/abandon"
			mv $path/$dir/truncate_figure/${temp}/$file $path/$dir/truncate_figure/${temp}/abandon
		fi
	done
done


