
import numpy as np

from pyproj import Proj


import argparse

def cal_dis(input_data):
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







def main(input,date):
    data=np.loadtxt(input)

    dis=cal_dis(data)

    print("%s %d"%(date,dis))


parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
parser.add_argument('--date', type=str, help='date of input shape')
args = parser.parse_args()




if (__name__ == '__main__'):
    main(args.input, args.date)
