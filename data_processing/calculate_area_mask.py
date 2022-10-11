import shapefile
from osgeo import ogr
import argparse
import shapely
from shapely.geometry import Polygon
from shapely.geometry import shape
from shapely.geometry import MultiPolygon
from pyproj import Proj
import numpy as np
import os
import datetime
parser = argparse.ArgumentParser()
parser.add_argument('--input', help='input gmt file')
parser.add_argument('--GID', help="input date")
parser.add_argument('--reference',help="reference gmt file")
args = parser.parse_args()

def PolyArea(x,y):
    return -0.5*(np.dot(x,np.roll(y,1))-np.dot(y,np.roll(x,1)))
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
def area(data):

    lo=data[:,0]
    la=data[:,1]

    pa = Proj("+proj=stere +lat_0=90.0 +lat_ts=70 +lon_0=-45")

    x, y = pa(lo, la)
    #cop = {"type": "Polygon", "coordinates": [zip(x, y)]}
    #b = shape(cop)
    return PolyArea(x,y)

def ref_length(input_data):
    lo = input_data[:, 0]
    la = input_data[:, 1]
    pa = Proj("+proj=stere +lat_0=90.0 +lat_ts=70 +lon_0=-45")

    x, y = pa(lo, la)
    length = 0
    x_1 = x[0:len(x) - 1]
    x_2 = x[1:len(x)]
    y_1 = y[0:len(y) - 1]
    y_2 = y[1:len(y)]
    dis_array = ((x_2 - x_1) ** 2 + (y_2 - y_1) ** 2) ** 0.5
    dis = np.sum(dis_array)
    return (dis)

if __name__=='__main__':
    input_data = np.loadtxt(args.input)
    ref_data=np.loadtxt(args.reference)
    area_data=area(input_data)
    reflength=ref_length(ref_data)
    print("%f %f %s"%(area_data/1e7,area_data/reflength,args.GID))
