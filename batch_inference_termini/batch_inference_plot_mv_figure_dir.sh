
#need to modify the data path first

para_file=para.ini
para_py=/home/staff/enze/Front_DL3/script/parameters.py
working_path=$(python2 ${para_py} -p ${para_file} working_root)
data_path=$(python2 ${para_py} -p ${para_file} data_path)

list=Glacier_ID_list_temp.txt
network=$1
temp=${network%.tar*}

if [  $network ];then
	echo "ok"
else
	echo "please input the network"
	exit 1
fi
cat $list | while read GID
do
	ID=${GID#*GID}
	GID2=GID_${ID}
	
	echo "bash batch_inference.sh $data_path/${GID}  $data_path/${GID}/polygon/${GID2}_cutting_polygon.gmt $network"
	if [ -f $data_path/${GID}/polygon/${GID2}_cutting_polygon.gmt ];then
		echo "bash batch_inference.sh $data_path/${GID}  $data_path/${GID}/polygon/${GID2}_cutting_polygon.gmt $network" 
		bash batch_inference.sh $data_path/${GID}  $data_path/${GID}/polygon/${GID2}_cutting_polygon.gmt $network
	elif [ -f $data_path/${GID}/polygon/${GID2}_cutting_polygon_shrink.gmt ];then
		echo "bash batch_inference.sh $data_path/${GID}  $data_path/${GID}/polygon/${GID2}_cutting_polygon_shrink.gmt $network"
		bash batch_inference.sh $data_path/${GID}  $data_path/${GID}/polygon/${GID2}_cutting_polygon_shrink.gmt $network

	else
		echo "no cutting polygon for $GID"
		continue
	fi

	echo "bash batch_truncate_termini.sh $data_path/${GID} $network $ID"
	bash batch_truncate_termini.sh $data_path/${GID} $network $ID
	
	echo "bash batch_plot_truncate.sh $data_path/${GID} $network"
	bash batch_plot_truncate.sh $data_path/${GID} $network
	
	#!!!!!!!!
	echo "bash batch_mv_back.sh $data_path/${GID} $network"	
#	bash batch_mv_back.sh $data_path/${GID} $network 

	echo "bash batch_abandon_empty_results.sh $data_path/${GID} $network"
	bash batch_abandon_empty_results.sh $data_path/${GID} $network
	old=0	
	for i in {1..3}
	do
		echo "length smoothness screen time: $i"
		echo "bash batch_smoothness_truncate.sh $data_path/${GID} $network $i"
		bash batch_smoothness_truncate.sh $data_path/${GID} $network $i
       
		echo "bash batch_cal_length_truncate.sh $data_path/${GID} $network $i"
		bash batch_cal_length_truncate.sh $data_path/${GID} $network $i

		echo "bash batch_abandon_results.sh $data_path/${GID} $network"
		bash batch_abandon_results.sh $data_path/${GID} $network
		count_l=$(ls -l $data_path/${GID}/${GID2}_Landsat-8/truncate_termini/${temp}/abandon/ | grep "^-" | wc -l)
		count_s1a=$(ls -l $data_path/${GID}/${GID2}_Sentinel-1_A/truncate_termini/${temp}/abandon/ | grep "^-" | wc -l)
		count_s1d=$(ls -l $data_path/${GID}/${GID2}_Sentinel-1_D/truncate_termini/${temp}/abandon/ | grep "^-" | wc -l)
		count_s2=$(ls -l $data_path/${GID}/${GID2}_Sentinel-2/truncate_termini/${temp}/abandon/ | grep "^-" | wc -l)
		count=$(($count_l+$count_s1a+$count_s1d+$count_s2))
		flag=$(($count-$old))
		old=$count
		if [ $flag -lt 15 ];then
			echo "the number of new abandoned results is $flag less than 15, move on"
			break
		else
			echo "the number of new abandoned results is $flag larger than 15, keep screening"
		fi
		
	done


	echo "bash put_together_truncate_termini.sh  $data_path/${GID} $network"
	bash put_together_truncate_termini.sh  $data_path/${GID} $network

	echo "bash batch_remove_duplicate.sh $data_path/${GID} $network $ID"
	bash batch_remove_duplicate.sh $data_path/${GID} $network $ID
	
	
	old=0	
	for i in {1..10}
	do
		echo "area change screen time :$i"
		echo "bash batch_merge.sh $data_path/${GID} $network"
		bash batch_merge.sh $data_path/${GID} $network
		echo "bash batch_area_cal2.sh $data_path/${GID} $network ${GID} $i"
		bash batch_area_cal2.sh $data_path/${GID} $network ${GID} $i
		echo "bash batch_abandon_results_time_series.sh $data_path/${GID} $network ${GID}"
	      	bash batch_abandon_results_time_series.sh $data_path/${GID} $network ${GID}
                
		
		count=$(ls -l $data_path/${GID}/truncate_termini/${temp}/abandon/ | grep "^-" | wc -l)
                flag=$(($count-$old))
                old=$count
                if [ $flag -lt 1 ];then
                        echo "the number of new abandoned results is $flag less than 1, move on"
                        break
                else
                        echo "the number of new abandoned results is $flag larger than 1, keep screening"
                fi
	done

#	for i in {1..10}
#	do
#		echo "flowline projection screen time :$i"
#		echo "bash batch_cal_flowline_proj_variation.sh $data_path/${GID} $network ${GID}"
#		bash batch_cal_flowline_proj_variation.sh $data_path/${GID} $network ${GID}

#        	echo "bash batch_abandon_results_proj_variation.sh $data_path/${GID} $network ${GID}"
#	 	bash batch_abandon_results_proj_variation.sh $data_path/${GID} $network ${GID}

#		count=$(ls -l $data_path/${GID}/truncate_termini/${temp}/abandon/ | grep "^-" | wc -l)
#               flag=$(($count-$old))
#                old=$count
#                if [ $flag -lt 1 ];then
#                        echo "the number of new abandoned results is $flag less than 1, move on"
#                        break
#                else
#                        echo "the number of new abandoned results is $flag larger than 1, keep screening"
#                fi
#	done


	bash batch_merge.sh $data_path/${GID} $network

	bash batch_area_cal.sh $data_path/${GID} $network ${GID}

	echo "bash batch_split_data_by_name.sh $data_path/${GID} $network ${GID}"
	bash batch_split_data_by_name.sh $data_path/${GID} $network ${GID}

	echo "bash batch_calculate_offset_sentinel.sh $data_path/${GID} $network ${GID}"
        bash batch_calculate_offset_sentinel.sh $data_path/${GID} $network ${GID}
	
	echo "bash batch_calculate_error.sh $data_path/${GID} $network ${GID}"
	bash batch_calculate_error.sh $data_path/${GID} $network ${GID}

	echo "bash batch_plot_time_series.sh $data_path/${GID} $network ${GID}"
	bash batch_plot_time_series.sh $data_path/${GID} $network ${GID}
	
	
	echo "bash batch_mv_abandon_duplicate.sh $data_path/${GID} $network ${GID}"
	bash batch_mv_abandon_duplicate.sh $data_path/${GID} $network ${GID}


	echo "bash batch_mv_truncate_figure_dir.sh $data_path/${GID} $network"
	bash batch_mv_truncate_figure_dir.sh $data_path/${GID} $network

done







