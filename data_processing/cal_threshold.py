import numpy as np

import argparse


parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
args = parser.parse_args()

data=np.loadtxt(args.input)

Q1=np.percentile(data,25)
Q3=np.percentile(data,75)
threshold=Q3+2*(Q3-Q1)
print(threshold)
