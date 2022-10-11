path=~/data1/Greenland_front_Mapping/data/
network=$1
temp2=${network%.tar*}
list=Glacier_ID_list.txt
cat $list | while read GID
do
	echo $GID
	ID=${GID#*GID}
        GID2=GID_${ID}
	echo $GID
	if [ -d $path/$GID ];then

		folder=(`ls $path/$GID/truncate_termini -rt`)
		temp=${folder[-2]}
		echo "bash batch_MC_dropout.sh $path/$GID $temp $GID $GID2 ~/Front_DL3 $network"
		#bash temp_plot.sh  $path/$GID $temp $GID $GID2 ~/Front_DL3 $network	
		bash batch_MC_dropout.sh $path/$GID $temp $GID $GID2 ~/Front_DL3 $network
		echo "bash MC_dropout_uncertainty.sh $path/$GID $temp $GID $temp2"
		bash MC_dropout_uncertainty.sh $path/$GID $temp $GID $temp2
	else
		echo "$GID is missing"
	fi


done
