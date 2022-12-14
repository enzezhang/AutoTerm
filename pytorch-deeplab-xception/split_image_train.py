#!/usr/bin/env python
# Filename: split_image 
"""
introduction: split a large image to many separate patches

authors: Huang Lingcao
email:huanglingcao@gmail.com
add time: 15 July, 2017

changed by Enze 18 Dec
I change the adj_overlay
"""
import sys,os,subprocess
from optparse import OptionParser

def sliding_window(image_width,image_height, patch_w,patch_h,start_x,start_y,adj_overlay_x=0,adj_overlay_y=0):
    """
    get the subset windows of each patch
    Args:
        image_width: width of input image
        image_height: height of input image
        patch_w: the width of the expected patch
        patch_h: the height of the expected patch
        adj_overlay: the extended distance (in pixel) to adjacent patch, make each patch has overlay with adjacent patch

    Returns: The list of boundary of each patch

    """
    if image_width <= start_x:
        start_x=int(image_width*0.3)
    if image_height <= start_y:
        start_y=int(image_height*0.3)
    #print("start_x is %d"%start_x)
    #print("start_y is %d"%start_y)
    
    count_x = int(int(image_width-start_x)/int(patch_w))
    count_y = int(int(image_height-start_y)/int(patch_h))

    leftW = int(image_width-start_x)%int(patch_w)
    leftH = int(image_height-start_y)%int(patch_h)
    #if leftW < patch_w/3 and count_x > 0:
    #    count_x = count_x - 1
    #    leftW = patch_w + leftW
    #else:
    if leftW==0:
        count_x=count_x
    else:
        count_x = count_x + 1
    #if leftH < patch_h/3 and count_y > 0:
    #    count_y = count_y - 1
    #    leftH = patch_h + leftH
    #else:
    if leftH==0:
        count_y=count_y
    else:

        count_y = count_y + 1

    # output split information
    f_obj = open('split_image_info.txt','w+')
    f_obj.writelines('### This file is created by split_image.py. mosaic_patches.py need it. Do not edit it\n')
    f_obj.writelines('image_width:%d\n' % image_width)
    f_obj.writelines('image_height:%d\n' % image_height)
    f_obj.writelines('expected patch_w:%d\n' % patch_w)
    f_obj.writelines('expected patch_h:%d\n'%patch_h)
    f_obj.writelines('adj_overlay_x:%d\n' % adj_overlay_x)
    f_obj.writelines('adj_overlay_y:%d\n' % adj_overlay_y)
    patch_boundary = []
    for i in range(0,count_x):
        f_obj.writelines('column %d\n:'%i)
        for j in range(0,count_y):
            w = patch_w
            h = patch_h
            if i==count_x -1:
                w = leftW
            if j == count_y - 1:
                h = leftH

            f_obj.write('%d ' % (i*count_y + j))

            # extend the patch
            xoff = max(i * patch_w+start_x - adj_overlay_x, start_x)  # i*patch_w
            yoff = max(j * patch_h+start_y - adj_overlay_y, start_y)  # j*patch_h
            xsize = min(i * patch_w+start_x + w + adj_overlay_x, image_width) - xoff  # w
            ysize = min(j * patch_h+start_y + h + adj_overlay_y, image_height) - yoff  # h

            new_patch = (xoff,yoff ,xsize, ysize)
            f_obj.writelines('xff:%d yoff:%d xsize:%d ysize:%d\n' % (xoff,yoff ,xsize, ysize))
            patch_boundary.append(new_patch)

        f_obj.writelines('\n')

    #f_obj.close()
    return patch_boundary

def sliding_window_test(image_width,image_height, patch_w,patch_h,adj_overlay_x=0,adj_overlay_y=0):
    """
    get the subset windows of each patch
    Args:
        image_width: width of input image
        image_height: height of input image
        patch_w: the width of the expected patch
        patch_h: the height of the expected patch
        adj_overlay: the extended distance (in pixel) to adjacent patch, make each patch has overlay with adjacent patch

    Returns: The list of boundary of each patch

    """

    count_x = int(image_width)/int(patch_w)
    count_y = int(image_height)/int(patch_h)

    leftW = int(image_width)%int(patch_w)
    leftH = int(image_height)%int(patch_h)
    # if leftW < patch_w/3 and count_x > 0:
    #     # count_x = count_x - 1
    #     leftW = patch_w + leftW
    # else:
    count_x = count_x + 1
    # if leftH < patch_h/3 and count_y > 0:
    #     # count_y = count_y - 1
    #     leftH = patch_h + leftH
    # else:
    count_y = count_y + 1

    # output split information
    f_obj = open('split_image_info_test.txt','w')
    f_obj.writelines('### This file is created by split_image.py. mosaic_patches.py need it. Do not edit it\n')
    f_obj.writelines('image_width:%d\n' % image_width)
    f_obj.writelines('image_height:%d\n' % image_height)
    f_obj.writelines('expected patch_w:%d\n' % patch_w)
    f_obj.writelines('expected patch_h:%d\n'%patch_h)
    f_obj.writelines('adj_overlay_x:%d\n' % adj_overlay_x)
    f_obj.writelines('adj_overlay_y:%d\n' % adj_overlay_y)
    patch_boundary = []
    for i in range(0,count_x):
        f_obj.write('column %d:'%i)
        for j in range(0,count_y):
            w = patch_w
            h = patch_h
            if i==count_x -1:
                w = leftW
            if j == count_y - 1:
                h = leftH

            f_obj.write('row %d ' % (i*count_y + j))

            # extend the patch
            xoff = max(i*patch_w,0)  # i*patch_w
            yoff = max(j*patch_h, 0) # j*patch_h
            xsize = min(i*patch_w + w,image_width) - xoff   #w
            ysize = min(j*patch_h + h, image_height) - yoff #h
            f_obj.write('xoff:%d yoff:%d xsize:%d ysize:%d '%(xoff,yoff,xsize,ysize))
            new_patch = (xoff,yoff ,xsize, ysize)
            patch_boundary.append(new_patch)

        f_obj.write('\n')

    f_obj.close()
    return patch_boundary




def split_image(input,output_dir,patch_w=1024,patch_h=1024,adj_overlay_x=0,adj_overlay_y=0):
    """
    split a large image to many separate patches
    Args:
        input: the input big images
        output_dir: the folder path for saving output files
        patch_w: the width of wanted patch
        patch_h: the height of wanted patch

    Returns: True is successful, False otherwise

    """
    if os.path.isfile(input) is False:
        print("Error: %s file not exist"%input)
        return False
    if os.path.isdir(output_dir) is False:
        print("Error: %s Folder not exist" % input)
        return False

    Size_str = os.popen('gdalinfo '+input + ' |grep Size').readlines()
    temp = Size_str[0].split()
    img_witdh = int(temp[2][0:len(temp[2])-1])
    img_height = int(temp[3])

    #print('input Width %d  Height %d'%(img_witdh,img_height))

    patch_boundary = sliding_window(img_witdh,img_height,patch_w,patch_h,adj_overlay_x,adj_overlay_y)

    index = 0
    pre_name = os.path.splitext(os.path.basename(input))[0]
    f_obj = open('split_image_info.txt', 'a+')
    f_obj.writelines("pre FileName:"+pre_name+'_p_\n')
    f_obj.close()

    for patch in patch_boundary:
        # print information
        #print(patch)
        output_path = os.path.join(output_dir,pre_name+'_p_%d.tif'%index)
        args_list = ['gdal_translate','-ot','Byte','-a_nodata', str(0),'-srcwin',str(patch[0]),str(patch[1]),str(patch[2]),str(patch[3]), input, output_path]
        ps = subprocess.Popen(args_list)
        returncode = ps.wait()
        if os.path.isfile(output_path) is False:
            print('Failed in gdal_translate, return codes: ' + str(returncode))
            return False
        index = index + 1



def main(options, args):
    if options.s_width is None:
        patch_width = 1024
    else:
        patch_width = int(options.s_width)
    if options.s_height is None:
        patch_height = 1024
    else:
        patch_height = int(options.s_width)

    adj_overlay_x = 0
    adj_overlay_y=0
    if options.extend is not None:
        adj_overlay = options.extend


    if options.out_dir is None:
        out_dir = "split_save"
    else:
        out_dir = options.out_dir
    if os.path.isdir(out_dir) is False:
        os.makedirs(out_dir)

    image_path = args[0]

    split_image(image_path,out_dir,patch_width,patch_height,adj_overlay_x,adj_overlay_y)


    pass

if __name__ == "__main__":
    usage = "usage: %prog [options] image_path"
    parser = OptionParser(usage=usage, version="1.0 2017-7-15")
    parser.description = 'Introduction: split a large image to many separate parts '
    parser.add_option("-W", "--s_width",
                      action="store", dest="s_width",
                      help="the width of wanted patches")
    parser.add_option("-H", "--s_height",
                      action="store", dest="s_height",
                      help="the height of wanted patches")
    parser.add_option("-e", "--extend_dis",type=int,
                      action="store", dest="extend",
                      help="extend distance (in pixel) of the patch to adjacent patch, make patches overlay each other")
    parser.add_option("-o", "--out_dir",
                      action="store", dest="out_dir",
                      help="the folder path for saving output files")

    (options, args) = parser.parse_args()
    if len(sys.argv) < 2 or len(args) < 1:
        parser.print_help()
        sys.exit(2)

    # if options.para_file is None:
    #     basic.outputlogMessage('error, parameter file is required')
    #     sys.exit(2)

    main(options, args)
