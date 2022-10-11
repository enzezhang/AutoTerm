import numpy as np
import argparse
from pyproj import Proj
from intersect import intersection
import os
import math
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
    x_i,y_i=pa(input[:,0],input[:,1])
    # x_b,y_b=pa(bed_data[:,0],bed_data[:,1])
    # # x_o,y_o=intersection(x_i, y_i, x_b, y_b)
    lo_o = []
    la_o = []
    for bed_item in bed:
        bed_data = np.loadtxt(bed_item.split('\n')[0])
        x_b,y_b=pa(bed_data[:,0],bed_data[:,1])
        x_o,y_o=intersection(x_i, y_i, x_b, y_b)
        lo,la=pa(x_o,y_o,inverse=True)
        #lo, la = intersection(input[:, 0], input[:, 1], bed_data[:, 0], bed_data[:, 1])
        if len(lo):
            for item in lo:
                lo_o.append(item)
            for item in la:
                la_o.append(item)
            # lo_o.append(lo)
            # la_o.append(la)

    lo_o = np.array(lo_o).flatten()
    la_o = np.array(la_o).flatten()
    # lo_o, la_o=intersection(input_data[:,0],input_data[:,1],bed_data[:,0],bed_data[:,1])
    # # lo_o,la_o=pa(x_o,y_o,inverse=True)
    temp = []
    for i in range(len(lo_o)):
        #print("%.7f %.7f" % (lo_o[i], la_o[i]))
        temp.append([lo_o[i], la_o[i]])
    output = []
    [output.append(i) for i in temp if not i in output]
    return output

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




def truncate_termini(input,intersect):
    ############for each intersection, find out which side it belongs to
    start = 0
    end = -1
    index=np.zeros(len(intersect))
    for i in range(len(intersect)):
        index[i]=closest_point(intersect[i],input)

    index_new=index-len(input)/2
    abs_index_new=np.abs(index_new)
    abs_index_new.all()
    if (abs_index_new >= 25).all():
        temp=np.argwhere(index_new<0)
        if (len(temp)):
            start=int(np.max(index[temp]))

        temp=np.argwhere(index_new>0)
        if (len(temp)):

            end=int(np.min(index[temp]))


    else:
        index_1=index[int(np.max(np.where(np.abs(index_new)<25)))]
        index_2=index[np.argmax(np.abs(index-index_1))]
        if index_1>index_2:
            start=int(index_2)
            end=int(index_1)
        elif index_1>index_2:
            start = int(index_1)
            end = int(index_2)
        else:
            end=index_1

    print(start, end)
    return input[start:end]

    ####### truncatate the termini with the intersect





def main(input,bed,output):

    input_data=np.loadtxt(input)
    bed_list=read_bed(bed)
    interction=get_intersect(input_data,bed_list)
    if len(interction):
        data=truncate_termini(input_data,interction)
        np.savetxt(output,data,fmt='%.7f',delimiter=' ')
    else:
        data=input_data
        np.savetxt(output, data, fmt='%.7f', delimiter=' ')












if (__name__ == '__main__'):
    # print(args)
    main(args.input,args.bed,args.output)
