import numpy as np
import argparse
from pyproj import Proj
import math
parser = argparse.ArgumentParser()
import datetime
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
from shapely.geometry import LineString
parser.add_argument('--input', type=str, help='input glacier termini')
parser.add_argument('--flowline', type=str, help='flowline')
parser.add_argument('--date', type=str, help='date')
args = parser.parse_args()
pa = Proj("+proj=stere +lat_0=90.0 +lat_ts=70 +lon_0=-45")


def convert_time(date):
    date=str(date)
    year=int(date[0:4])
    month=int(date[4:6])
    day=int(date[6:8])
    d1 = datetime.datetime(year,month,day)
    d2=datetime.datetime(year,1,1)
    intervel=d1-d2
    out_date=year+(intervel.days)/365.25
    return out_date

def calculate_dis(x1,y1,x2,y2):
    
    return math.sqrt((x1-x2)**2+(y1-y2)**2)





def main(input,flowline,date):

    input_data=np.loadtxt(input)
    date_num=convert_time(date)
    firstline=LineString(input_data)
    flowline_data=np.loadtxt(flowline)
    secondline=LineString(flowline_data)
    lo,la = firstline.intersection(secondline).xy
    lo=lo[0]
    la=la[0]
    print("%f %f %f"%(lo,la,date_num))




if (__name__ == '__main__'):
    # print(args)
    main(args.input,args.flowline,args.date)
