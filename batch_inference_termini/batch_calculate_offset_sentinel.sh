#!/usr/bin/env bash
path=$1
network=$2
script=/home/staff/enze/Front_DL3/data_processing/calculate_area.py
script2=/home/staff/enze/Front_DL3/data_processing/find_offset.py
GID=$3
temp=${network%.tar*}
cd $path/truncate_termini/${temp}/duplicate
rm -r merge_two 
mkdir merge_two
rm Sentinel-1_A_offset.txt
for file in `ls *Sentinel1*_A_*.gmt`
do
	date=(`echo $file|cut -d '_' -f 1`)
	if [ `ls -A $path/truncate_termini/${temp}/${date}*.gmt.invert` ];then

		other=(`ls $path/truncate_termini/${temp}/${date}*.gmt.invert`)
		satellite=(`echo ${other[0]}|cut -d '_' -f 2`)
		if [ "$satellite" == "Sentinel1" ];then
			continue
			echo "the duplicate file is ${other[0]}"
		else
			cat ${other[0]} $file > $path/truncate_termini/${temp}/merge_two/$file
			python $script --input $path/truncate_termini/${temp}/merge_two/$file --reference ${other[0]} --date $date >> Sentinel-1_A_offset.txt
		fi
	else
		echo "no file for $file"
	fi
done


rm Sentinel-1_D_offset.txt
for file in `ls *Sentinel1*_D_*.gmt`
do
        date=(`echo $file|cut -d '_' -f 1`)
        if [ `ls -A $path/truncate_termini/${temp}/${date}*.gmt.invert` ];then

                other=(`ls $path/truncate_termini/${temp}/${date}*.gmt.invert`)
                satellite=(`echo ${other[0]}|cut -d '_' -f 2`)
                if [ "$satellite" == "Sentinel1" ];then
                        continue
                        echo "the duplicate file is ${other[0]}"
                else
                        cat ${other[0]} $file > $path/truncate_termini/${temp}/merge_two/$file
                        python $script --input $path/truncate_termini/${temp}/merge_two/$file --reference ${other[0]} --date $date >> Sentinel-1_D_offset.txt
                fi
        else
                echo "no file for $file"
        fi
done
if [ -f Sentinel-1_A_offset.txt ];then

	offset_s1a=(`python $script2 --input Sentinel-1_A_offset.txt`)
else
	offset_s1a=0
fi
if [ -f Sentinel-1_D_offset.txt ];then

	offset_s1d=(`python $script2 --input Sentinel-1_D_offset.txt`)
else
	offset_s1d=0
fi

echo "Sentinel-1 A $GID offset is $offset_s1a"
echo "Sentinel-1 D $GID offset is $offset_s1d"
if [ -f $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-D_backup.txt ];then
	echo "backup exist"
else
	mv $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-D.txt $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-D_backup.txt
fi

if [ -f $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-A_backup.txt ];then
        echo "backup exist"
else
        mv $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-A.txt $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-A_backup.txt
fi

cat $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-A_backup.txt | gawk '{printf"%f %f %f %d\n",$1-offset_s1a,$2,$3,$4}' offset_s1a="$offset_s1a" > $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-A.txt

cat $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-D_backup.txt | gawk '{printf"%f %f %f %d\n",$1-offset_s1d,$2,$3,$4}' offset_s1d="$offset_s1d" > $path/truncate_termini/${temp}_time_series/accu/${GID}_Sentinel1-D.txt



