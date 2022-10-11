import os
import numpy as np
import argparse



parser = argparse.ArgumentParser()
parser.add_argument('--uncertainty', type=str, help='absolute path of input shape')
parser.add_argument('--GID', type=str, help='absolute path of output shape')
parser.add_argument('--satellite', type=str, help='absolute path of output shape')
args = parser.parse_args()


uncertainty_all=np.loadtxt(args.uncertainty)

uncertainty=uncertainty_all[int(args.GID)-1,:]

if args.satellite=='Landsat5':
    index=2
elif args.satellite=='Landsat7':
    index=3
elif args.satellite=='Landsat8':
    index=4
elif args.satellite=='Sentinel1':
    index=5
elif args.satellite=='Sentinel2':
    index=6
else:
    print("N/A")
    os._exit()

MC=uncertainty[index]
duplicate=uncertainty[7]

if MC==0:
    if duplicate==0:
        final_uncertainty="N/A"
    else:
        final_uncertainty=duplicate
elif duplicate==0:
    final_uncertainty=MC 
else:
    final_uncertainty=(MC+duplicate)/2
print(final_uncertainty)




