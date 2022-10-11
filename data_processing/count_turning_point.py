import sys
import numpy as np
from shapely.geometry import shape
from pyproj import Proj
import numpy.linalg as LA

import argparse

def tri_order(x,y):
    if ((x[1]-x[0])*(y[2]-y[1])-(x[2]-x[1])*(y[1]-y[0])>0):
        # print('clock wise')
        return True
    elif ((x[1]-x[0])*(y[2]-y[1])-(x[2]-x[1])*(y[1]-y[0])<0):
        # print("conter clock wise")
        return False
    else:
        #print("the triangle is not in the correct format")
        pass
def extract_points(points):

    length=len(points)
    lo=np.zeros([length,1])
    la=np.zeros([length,1])
    for i in range(length):
        point=points[i]
        lo[i], la[i]=point[0], point[1]
    return lo,la



def vibration_freq(x,y):
    clock=0
    conter_clock=0
    for i in range(len(x)-2):
        if tri_order(x[i:i+3],y[i:i+3]):
            clock+=1
        else:
            conter_clock+=1
    notch_norm=(float(clock)/(len(x)-3))
    freq=16*np.power((notch_norm-0.5),4)-8*np.power((notch_norm-0.5),2)+1
    # print("clock points are %d, conter clock points are %d"%(clock,conter_clock))
    # print("notch norm is %f"%(notch_norm))
    # print("frequency of vibration is %f"%(freq))
    return freq


def PJcurvature(x, y):
    """
    input  : the coordinate of the three point
    output : the curvature and norm direction
    """
    t_a = LA.norm([x[1] - x[0], y[1] - y[0]])
    t_b = LA.norm([x[2] - x[1], y[2] - y[1]])

    M = np.array([
        [1, -t_a, t_a ** 2],
        [1, 0, 0],
        [1, t_b, t_b ** 2]
    ])

    a = np.matmul(LA.inv(M), x)
    b = np.matmul(LA.inv(M), y)

    kappa = 2 * (a[2] * b[1] - b[2] * a[1]) / (a[1] ** 2. + b[1] ** 2.) ** (1.5)
    return kappa, [b[1], -a[1]] / np.sqrt(a[1] ** 2. + b[1] ** 2.)

def count_turning_point(x,y):
    number=0
    for i in range(len(x) - 2):
        if np.abs((y[i+1]-y[i])*(x[i+2]-x[i])-(y[i+2]-y[i])*(x[i+1]-x[i])) > 0.000001:
            kappa,norm_temp=PJcurvature(x[i:i+3],y[i:i+3])
            if kappa>0.001:
                number=number+1





    return number




def main(input,date):
    data=np.loadtxt(input)
    lo=data[:,0]
    la=data[:,1]
    pa = Proj("+proj=stere +lat_0=90.0 +lat_ts=70 +lon_0=-45")
    x, y = pa(lo, la)
    # freq=vibration_freq(x,y)
    turning_point=count_turning_point(x,y)


    print("%s %d"%(date,turning_point))


parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
parser.add_argument('--date', type=str, help='date of input shape')
args = parser.parse_args()




if (__name__ == '__main__'):
    main(args.input, args.date)
