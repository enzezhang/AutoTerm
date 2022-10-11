import numpy as np

import argparse


parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
args = parser.parse_args()

data=np.loadtxt(args.input)
min=np.min(data[:,1])
max=np.max(data[:,1])
print(min,max)
