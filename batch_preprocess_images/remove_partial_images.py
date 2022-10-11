import numpy as np
import imageio

import argparse


def main(input):
    # data=cv2.imread(input)
    # print(data.shape)
    data2=imageio.imread(input)
    # print(data2.shape)
    # print(data2.size)
    index=np.argwhere(data2==0)
    if (len(index)>float(data2.size/10)):
        print('remove')
    else:
        print('pass')





parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')

args = parser.parse_args()




if (__name__ == '__main__'):
    main(args.input)
