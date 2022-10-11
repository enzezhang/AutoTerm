import numpy as np

import argparse


parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
args = parser.parse_args()

data=np.loadtxt(args.input)
data=data[:,1]
if len(data) > 9:

    ind = np.argpartition(data, -9)[-9:]
    data=np.delete(data,ind)
    average=np.mean(data)
else:
    average=0
print(average)
