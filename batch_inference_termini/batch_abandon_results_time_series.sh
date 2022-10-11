#!/bin/bash
path=$1
network=$2
GID=$3
temp=${network%.tar*}
mkdir $path/truncate_termini/${temp}/abandon
####remove based on time series
if [ -f $path/truncate_termini/${temp}_time_series/${GID}_all.txt ];then
	echo $path/truncate_termini/${temp}_time_series/${GID}_all.txt
	cat $path/truncate_termini/${temp}_time_series/${GID}_all.txt |awk 'function abs(v) {return v < 0 ? -v : v} {printf("%.5f\n",abs($1))}' > area_change.txt
        threshold=(`python /home/staff/enze/Front_DL3/data_processing/cal_threshold.py --input area_change.txt`)
        echo "threshold for ${temp}_${GID}_all.txt are $threshold"
	count=(`awk '{print NR}' $path/truncate_termini/${temp}_time_series/${GID}_all.txt | tail -n1`)
	i=1
	while (($i<=$count))
	do
	while read line
        do
		echo $i
		echo $line
                date=(`echo $line| awk '{print $3}'`)
                area=(`echo $line| awk 'function abs(v) {return v < 0 ? -v : v} {printf("%.5f\n",abs($1))}'`)
		echo "go through $date"
		if [ `echo "$area > $threshold"|bc` -eq 1 ];then
			name=(`ls $path/truncate_termini/${temp}/${date}*.gmt`)
			echo $name
			name2=(`echo ${name##*/}`)
			satellite=(`echo $name2 |cut -d '_' -f 2`)
			echo $satellite
			if [ $satellite = "Sentinel1" ];then
				check_number=10
			else
				check_number=5
			fi
			echo "need to check $date $area"
			j=1
			while (($j<=$check_number))
			do
				k=$[i+j]
				echo $k
				while read line2
				do
					echo "need to check the next $j; $line2"
					date2=(`echo $line2| awk '{print $3}'`)
					area2=(`echo $line2| awk 'function abs(v) {return v < 0 ? -v : v} {printf("%.5f\n",abs($1))}'`)
					if [ `echo "$area2 > $threshold"|bc` -eq 1 ];then
						name=(`ls $path/truncate_termini/${temp}/${date}*.gmt`)
                                        	echo "mv $name $path/truncate_termini/${temp}/abandon"
                                        	mv $name $path/truncate_termini/${temp}/abandon
						i=$[i+1]
						echo "break 2"
                                        	break 2
					else
						continue
					fi
				done << EOF
`sed -n ${k}p $path/truncate_termini/${temp}_time_series/${GID}_all.txt`
EOF
				j=$[j+1]
			done
		fi
		i=$[i+1]
        done << EOF
`sed -n ${i}p $path/truncate_termini/${temp}_time_series/${GID}_all.txt`
EOF
done
else
        echo "no time series for ${temp}_${dir}"
fi
rm $path/truncate_termini/${temp}/*.invert
rm -r $path/truncate_termini/${temp}/merge_two


