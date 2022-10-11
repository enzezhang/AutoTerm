#!/bin/bash

path=$1
network=$2
temp=${network%.tar*}
cd $path
if [ -d truncate_termini ];then
	echo "truncate_termini exist"
else
	mkdir truncate_termini
fi
if [ -d truncate_termini/$temp ];then
	echo "truncate_termini/$temp exist"
	echo "rm -r truncate_termini/$temp/*"
	rm -r truncate_termini/$temp/*
else
	mkdir truncate_termini/$temp
fi


for dir in `ls |grep "GID"`
do
	if [ -d $path/$dir/truncate_termini/$temp ];then
		cp $path/$dir/truncate_termini/$temp/*.gmt $path/truncate_termini/$temp
	fi
done

