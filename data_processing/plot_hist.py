import numpy as np
import matplotlib.pyplot as plt
import argparse
# Fixing random state for reproducibility
import matplotlib
matplotlib.use('Agg')
parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
parser.add_argument('--output', type=str, help='date of input shape')
args = parser.parse_args()


data=np.loadtxt(args.input)
Q1=np.percentile(data,25)
Q3=np.percentile(data,75)
threshold=Q3+1.5*(Q3-Q1)
threshold_2=Q1-1.5*(Q3-Q1)
# the histogram of the data
n, bins, patches = plt.hist(data, 100, density=False, facecolor='g', alpha=0.75)

plt.vlines(threshold,0,50)
plt.vlines(threshold_2,0,50)
plt.xlabel('smoothness')
plt.ylabel('count')
plt.title('Histogram of smoothness')
#plt.xlim(40, 160)
#plt.ylim(0, 0.03)
plt.grid(True)
plt.savefig(args.output)
