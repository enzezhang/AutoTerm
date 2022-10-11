#!/bin/bash
#rm gmt.conf
gmt gmtset PS_MEDIA = 90cx120c
gmt gmtset MAP_FRAME_TYPE plain
gmt gmtset FONT_ANNOT_PRIMARY = +22p,Helvetica,black
gmt gmtset FONT_ANNOT_SECONDARY = +22p,Helvetica,black
gmt gmtset FONT_LABEL = +22p,Helvetica,black

path=$1
GID=$2
PS=$3
error_Landsat=$4

script=/home/staff/enze/Front_DL3/data_processing/find_min_max.py


area_change_all=$path/${GID}_all.txt
area_change_Landsat8=$path/${GID}_Landsat8.txt

area_change_sentinel1a=$path/${GID}_Sentinel1-A.txt
area_change_sentinel1d=$path/${GID}_Sentinel1-D.txt
area_change_sentinel2=$path/${GID}_Sentinel2.txt

# echo $area_change_sentinel2

cat $area_change_all  | awk '{print $3,$1}' > temp.txt
read min max<<<$(python $script --input temp.txt)
# echo $min
# echo $max
min_new=$(echo $min|awk '{print $1*1.3}')
max_new=$(echo $max|awk '{print $1*1.3}')
y_interval=$(echo "(($max_new)-($min_new))"|bc | awk '{printf("%.3f\n"),$1/5}')
temp=$(echo "(($max_new)-($min_new))"|bc | awk '{printf("%.3f\n"),$1*0.7}')

max_GID=$(echo "(($min_new)+($temp))"|bc | awk '{printf("%.3f\n"),$1}')
# echo $max_GID
R=2013/2021/$min_new/$max_new
J=X12i/4i
D=jTL+w1c+o0.2c/0.2c

gmt psbasemap -J$J -R$R -Ba1/a${y_interval}WSne -K -P -X2i -Y5.5i> $PS


y_range=$(echo "(($max_new)-($min_new))"| bc  | awk '{printf("%.5f\n"),$1}')

echo "$y_range,$error_Landsat"
error_Landsat_plot=$(echo "$y_range $error_Landsat"| awk '{printf("%.5f\n"),4/$1*$2}')
error_S1D_plot=$(echo "$y_range $error_S1D"| awk '{printf("%.5f\n"),4/$1*$2}')
error_S1A_plot=$(echo "$y_range $error_S1A"| awk '{printf("%.5f\n"),4/$1*$2}')
echo $error_Landsat_plot

#cat $path  | awk '{print $3,$1}' |gmt psxy -J$J -R$R -Sc0.3c   -W1p,black  -K -O >> $PS

cat $area_change_Landsat8 | awk '{print $3,$1,error_Landsat_plot}' error_Landsat_plot="$error_Landsat" |gmt psxy -J$J -R$R -Sc0.1i -W1p,red -Ey+p1p -K -O >> $PS

cat $area_change_sentinel1a | awk '{print $3,$1,error_S1A_plot}' error_S1A_plot="$error_Landsat" |gmt psxy -J$J -R$R -Sc0.1i -W1p,green -Ey+p1p  -K -O >> $PS
cat $area_change_sentinel1d| awk '{print $3,$1,error_S1D_plot}' error_S1D_plot="$error_Landsat"|gmt psxy -J$J -R$R -Sc0.1i  -W1p,green -Ey+p1p -K -O >> $PS
cat $area_change_sentinel2 | awk '{print $3,$1,error_Landsat_plot}' error_Landsat_plot="$error_Landsat"|gmt psxy -J$J -R$R -Sc0.1i -Ey+p1p -W1p,purple  -K -O >> $PS



echo 2014 $max_GID $GID | gmt pstext -R$R -J$J -F+f22p,1,black -K -O >>$PS



Jl=X2i/5i
Rl=0/1/0/1

echo 0.2 0.3 "Area change (10@+7@+ m@+2@+)"| gmt pstext -J$Jl -R$Rl -F+f22p,0,black+a90+jTL -O -X-1.8i -Y-1i  >>$PS


###plot legend
#Js=X3.5i/1i
#Rs=0/2/0/2
#gmt psbasemap -J$Js -R$Rs -Ba0 -B+gwhite -X1.8i -Y3.95i -K -O >>$PS




#gmt psxy -J$Js -R$Rs -Sc0.3c -Gwhite -W1p,black	 -K -O <<EOF>> $PS
#0.3 1.6
#EOF
#echo 0.7 1.6 Sentinel-2 |gmt pstext -J$Js -R$Rs -F+f22p,0,black+jML -K -O >>$PS


#gmt psxy -J$Js -R$Rs -Sc0.3c -Gwhite -W1p,red -K -O <<EOF>> $PS
#0.3 1
#EOF
#echo 0.7 1 Landsat-8 |gmt pstext -J$Js -R$Rs -F+f22p,0,black+jML -O -K >>$PS


#gmt psxy -J$Js -R$Rs -Sc0.3c -Gwhite -W1p,blue -K -O <<EOF>> $PS
#0.3 0.4
#EOF
#echo 0.7 0.4 Sentinel-1 |gmt pstext -J$Js -R$Rs -F+f22p,0,black+jML -O >>$PS



gmt psconvert -E300 -A+s50c -Tg $PS
rm $PS
# gmt psconvert -E400 -A $PS
