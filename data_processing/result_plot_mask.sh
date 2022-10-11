#!/bin/bash

rm gmt.* 

imagename=$1
calving_line=$2
calving_line2=$3
PS=$4
gmt gmtset MAP_FRAME_TYPE plain
gmt gmtset FONT_ANNOT_PRIMARY = +14p,Helvetica,black
gmt gmtset FORMAT_GEO_OUT = ddd:mm:ssF	

R=$5/$6/$7/$8
J=M16



gmt psbasemap -J$J -R$R -K -V -P -Bxa -Bya -BWSen > $PS
pwd
echo "gmt grdimage $imagename -R$R -J$J -Csar1.cpt -K -O -Q >>$PS"
gmt grdimage $imagename -R$R -J$J -K -O -Q >>$PS
gmt psxy -R$R -J$J -A -W1.5p,blue $calving_line2 -O -K >>$PS
gmt psxy -R$R -J$J -A -W1.5p,red $calving_line -O >>$PS
gmt psconvert -E300 -A $PS
rm $PS
