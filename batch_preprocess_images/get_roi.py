import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--id', help='Glacier ID')
args = parser.parse_args()
inventory=np.loadtxt('/home/staff/enze/data1/Greenland_front_Mapping/data/ROI_new_ID.txt')


def main():
    id=args.id
    index=np.argwhere(inventory[:,0]==int(id))
    print(*inventory[index,1:5].flatten(),sep=' ')




if (__name__ == '__main__'):
    main()
