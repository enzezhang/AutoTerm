import numpy as np

import argparse


parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
args = parser.parse_args()

data=np.loadtxt(args.input)
Q1=np.percentile(data,25)
Q3=np.percentile(data,75)
threshold_1=Q3+1.5*(Q3-Q1)
threshold_2=Q1-1.5*(Q3-Q1)
print(threshold_1,threshold_2)
