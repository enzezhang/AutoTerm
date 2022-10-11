import numpy as np
import argparse
from pyproj import Proj
import math
parser = argparse.ArgumentParser()
import datetime
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
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


def closest_point(point,points):
    index=0
    dis=9999999999
    for i in range(len(points)):
        dis1=calculate_dis(point[0],point[1],points[i,0],points[i,1])
        if dis1<=dis:
            dis=dis1
            index=i

    return index

def projecting_to_flowline(input,flowline,date):
    x,y=pa(input[:,0],input[:,1])
    x_f,y_f=pa(flowline[:,0],flowline[:,1])
    points=np.array([x_f,y_f]).T
    index=np.zeros(len(x))
    date_num = convert_time(date)
    for i in range(len(x)):
        index[i]=closest_point(np.array([x[i],y[i]]),points)


    n, bins, patches = plt.hist(index, int(len(index)), density=False, facecolor='g', alpha=0.75)
    projection=bins[np.argmax(n)]





    print("%f %f %s"%(np.mean(projection),date_num,date))




def main(input,flowline,date):

    input_data=np.loadtxt(input)
    flowline_data=np.loadtxt(flowline)
    projecting_to_flowline(input_data,flowline_data,date)



if (__name__ == '__main__'):
    # print(args)
    main(args.input,args.flowline,args.date)
