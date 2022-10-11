import numpy as np
import matplotlib.pyplot as plt
import argparse
# Fixing random state for reproducibility
import matplotlib
matplotlib.use('Agg')
parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
args = parser.parse_args()


data=np.loadtxt(args.input)
length=len(data)
if data.ndim==1:
    print(data[0])
else:
    data=data[:,0]
# threshold=np.percentile(data,95)
# threshold_2=np.percentile(data,5)
# the histogram of the data
    print(np.mean(data))
