path=~/data1/Greenland_front_Mapping/data/
out=$path/MC_results_Sep25.txt

list=Glacier_ID_list_all.txt
rm $out
cat $list | while read GID
do
	echo $GID
	ID=${GID#*GID}
        GID2=GID_${ID}
	echo $GID
	if [ -d $path/$GID/MC_dropout ];then
		if [ -f $path/$GID/MC_dropout/MC_uncertainty_${GID2}_Landsat-8.txt ];then
			file=$path/$GID/MC_dropout/MC_uncertainty_${GID2}_Landsat-8.txt
			L8=(`python /home/staff/enze/Front_DL3/data_processing/find_average.py --input $file`)
		else
			echo "no $GID Landsat-8 MC"
			L8=0
		fi

		if [ -f $path/$GID/MC_dropout/MC_uncertainty_${GID2}_Sentinel-1_A.txt ];then
                        file=$path/$GID/MC_dropout/MC_uncertainty_${GID2}_Sentinel-1_A.txt
                        S1a=(`python /home/staff/enze/Front_DL3/data_processing/find_average.py --input $file`)
                else
                        echo "no $GID Sentinel-1A MC"
                        S1a=0
                fi

		if [ -f $path/$GID/MC_dropout/MC_uncertainty_${GID2}_Sentinel-1_D.txt ];then
                        file=$path/$GID/MC_dropout/MC_uncertainty_${GID2}_Sentinel-1_D.txt
                        S1d=(`python /home/staff/enze/Front_DL3/data_processing/find_average.py --input $file`)
                else
                        echo "no $GID Sentinel-1D MC"
                        S1d=0
                fi
		if [ $S1a = 0 ] && [ $S1d = 0 ];then
			S1=0
		elif [ $S1d = 0 ];then
			S1=$S1a
		elif [ $S1a = 0 ];then
			S1=$S1d
		else
			S1=$(echo "scale=2;($S1a+$S1d)/2"|bc)
		fi


		if [ -f $path/$GID/MC_dropout/MC_uncertainty_${GID2}_Sentinel-2.txt ];then
                        file=$path/$GID/MC_dropout/MC_uncertainty_${GID2}_Sentinel-2.txt
                        S2=(`python /home/staff/enze/Front_DL3/data_processing/find_average.py --input $file`)
                else
                        echo "no $GID Sentinel-2 MC"
                        S2=0
                fi
		echo "$GID Landsat-8: $L8 Sentinel-1: $S1 Sentinel-2: $S2"
		echo $GID $L8 $S1 $S2 >>$out


		





	
	else
		echo "$GID is missing"
	fi


done
