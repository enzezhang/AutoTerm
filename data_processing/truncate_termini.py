import numpy as np
import argparse
from pyproj import Proj
from intersect import intersection
import os
import math
from matplotlib import path
parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='input glacier termini')
parser.add_argument('--bed', type=str, help='boundary of bed rock')
parser.add_argument('--output', type=str, help='output file name')
args = parser.parse_args()
pa = Proj("+proj=stere +lat_0=90.0 +lat_ts=70 +lon_0=-45")

def read_bed(bed):
    commend=("ls %s"%bed)
    file=(os.popen(commend).readlines())
    # print(file)
    # for i in range(len(file)):
    #     print(file[i].split('\n')[0])
    return file


def get_intersect(input,bed):
    # x_i,y_i=pa(input_data[:,0],input_data[:,1])
    # x_b,y_b=pa(bed_data[:,0],bed_data[:,1])
    # # x_o,y_o=intersection(x_i, y_i, x_b, y_b)
    start=0
    end=len(input)
    for bed_item in bed:
        bed_data = np.loadtxt(bed_item.split('\n')[0])
        bed_polygon = path.Path(bed_data)
        flag=bed_polygon.contains_points(input)
        index_temp=np.where(flag>0)
        if (np.abs(np.median(index_temp)-len(input) / 2)< len(input)/10):
            continue

        # print(np.median(index_temp),len(input) / 2)

        lo, la = intersection(input[:, 0], input[:, 1], bed_data[:, 0], bed_data[:, 1])
        if len(lo):
            index = np.zeros(len(lo))
            for i in range(len(lo)):
                # print("%.7f %.7f" % (lo_o[i], la_o[i]))
                temp=([lo[i], la[i]])
                index[i]=closest_point(temp, input)
                index_new = index - len(input) / 2


            if (np.median(index_temp)> len(input) / 2) and (index[np.argmin(np.abs(index_new))]<end) :
                end=index[np.argmin(np.abs(index_new))]
            elif (np.median(index_temp)< len(input) / 2) and (index[np.argmin(np.abs(index_new))]>start):
                start=index[np.argmin(np.abs(index_new))]




    return int(start),int(end)

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







def main(input,bed,output):

    input_data=np.loadtxt(input)
    bed_list=read_bed(bed)
    start,end=get_intersect(input_data,bed_list)
    print(start,end)
    data=input_data[start:end]
    np.savetxt(output, data, fmt='%.7f', delimiter=' ')












if (__name__ == '__main__'):
    # print(args)
    main(args.input,args.bed,args.output)