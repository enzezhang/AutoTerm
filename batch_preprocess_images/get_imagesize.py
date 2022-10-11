import argparse
from PIL import Image
parser = argparse.ArgumentParser()
parser.add_argument('--image', help='Glacier ID')
args = parser.parse_args()
img=Image.open(args.image)
print("%d %d"%(img.size[0],img.size[1]))