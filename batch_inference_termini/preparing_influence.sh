#!/bin/bash
path=$1
if [ -d ./list ];then
        echo "list exist"
else
        mkdir list
fi
	rm list/*test*.txt
find ${path}/*.tif > list/test.txt
split -dl 50 -a 4 --additional-suffix=.txt list/test.txt list/test
