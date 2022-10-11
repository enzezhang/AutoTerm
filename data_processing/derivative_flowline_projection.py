import numpy as np
import argparse
import matplotlib.pyplot as plt
import datetime

parser=argparse.ArgumentParser()
parser.add_argument('--input',help='input area change file')
parser.add_argument('--output',help='path to stole retreat rate')
args=parser.parse_args()

def derivative(data):
    deri=np.zeros(len(data))
    for i in range(1,len(data)):
        deri[i]=data[i]-data[i-1]
    return deri


if __name__=='__main__':
    input_data=np.loadtxt(args.input)
    #for i in range(len(input_data)):
    #    input_data[i,2]=convert_time(input_data[i,2])
    accu=np.zeros(input_data.shape)
    accu[:,0]=derivative(input_data[:,0])
    accu[:, 1] = input_data[:, 1]
    accu[:,2]=input_data[:,2]
    np.savetxt(args.output,accu,fmt="%.5f %.5f %d",delimiter=" ")
