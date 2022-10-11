#!/bin/bash

data=$1
dir=$2
GID=$3
network=$4
out=$5
rm $out/${GID}_Landsat5.txt $out/${GID}_Landsat7.txt
cd $dir
i=0
count=(`awk '{print NR}' $data|tail -n1`)
while(($i<$count))
do
        temp=(`sed -n ''$[i+1]'p' $data| awk '{print $4}'`)
	echo $temp
        file=(`ls ${temp}*.gmt`)
        if [ ${#file[@]} \> 1 ];then
                echo ${file[@]}
                echo "choose only one file"
                temp2=${file[0]}
                unset file
                file=$temp2
                echo ${file[@]}
        fi
        if [ "${file}" = ${temp}_Landsat5_${GID}_stretch.gmt ];then
                sed -n ''$[i+1]'p' $data >> $out/${GID}_Landsat5.txt
        elif [ "${file}" = ${temp}_Landsat7_${GID}_stretch.gmt ];then
                sed -n ''$[i+1]'p' $data >> $out/${GID}_Landsat7.txt

        else
                echo "error"
                sleep 5
        fi

        i=$[i+1]
done
