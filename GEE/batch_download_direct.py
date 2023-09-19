import ee
import os
ee.Authenticate()
ee.Initialize()
import requests
import zipfile
import geetools
import time
start = ee.Date('2013-02-01')
end = ee.Date('2023-07-01')

download_list=open('Glacier_ID_list_download_1.txt')
line = download_list.readline()
sleeptime=0
while line:
    temp=line.split(' ')
    GID=str(temp[0])
    lomin=float(temp[1])
    lamin = float(temp[2])
    lomax = float(temp[3])
    lamax = float(temp[4])

    print(lomin,lamin,lomax,lamax)

    geometry = ee.Geometry.Rectangle([lomin, lamin, lomax, lamax])

    #download Landsat-7
    # start = ee.Date('1999-01-01')
    # end = ee.Date('2014-01-01')
    # sel_bands = ['B8']

    # data_product = 'LANDSAT/LE07/C01/T1'

    # filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
    #     sel_bands).filterMetadata('CLOUD_COVER', 'less_than', 60)

    # save_res = 15

    # save_folder = GID + '_Landsat-7'
    # command="mkdir "+save_folder
    # os.system(command)

    # filtered_list=filteredCollection.toList(filteredCollection.size())

    # for i in range(filtered_list.size().getInfo()):
    #     image=ee.Image(filtered_list.get(i)).clip(geometry)
    #     fname = image.get('system:id').getInfo().split('/')[-1]
    #     # print(fname)
    #     print("downloading %s"%fname)
    #     url = image.getDownloadURL()
    #     # print(url)
    #     r=requests.get(url)
    #     name='./'+save_folder+'/'+'data.zip'
    #     path='./'+save_folder
    #     print(name)
    #     with open(name, 'wb') as f:
    #             f.write(r.content)
        # try:

        #     with zipfile.ZipFile(name) as f:
        #         files = f.namelist()
        #         f.extractall(path)
        #     os.remove(name)
        # except zipfile.BadZipFile:
        #     print('Skipping - Not a valid ZIP file')
        # except Exception as e:
        #     print('Error extracting')


    # #download Landsat-5

    # start = ee.Date('1984-01-01')
    # end = ee.Date('2012-05-05')
    # sel_bands = ['B3']

    # data_product = 'LANDSAT/LT05/C01/T1'

    # filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
    #     sel_bands).filterMetadata('CLOUD_COVER', 'less_than', 60)
    # save_res = 30

    # save_folder = GID + '_Landsat-5'
    # command="mkdir "+save_folder
    # os.system(command)

    # filtered_list=filteredCollection.toList(filteredCollection.size())

    # for i in range(filtered_list.size().getInfo()):
    #     image=ee.Image(filtered_list.get(i)).clip(geometry)
    #     fname = image.get('system:id').getInfo().split('/')[-1]
    #     # print(fname)
    #     print("downloading %s"%fname)
    #     url = image.getDownloadURL()
    #     # print(url)
    #     r=requests.get(url)
    #     name='./'+save_folder+'/'+'data.zip'
    #     path='./'+save_folder
    #     print(name)
    #     with open(name, 'wb') as f:
    #             f.write(r.content)
        # try:

        #     with zipfile.ZipFile(name) as f:
        #         files = f.namelist()
        #         f.extractall(path)
        #     os.remove(name)
        # except zipfile.BadZipFile:
        #     print('Skipping - Not a valid ZIP file')
        # except Exception as e:
        #     print('Error extracting')





    #download Landsat-8
    # sel_bands = ['B8']

    # data_product = 'LANDSAT/LC08/C01/T1'

    # filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
    #     sel_bands).filterMetadata('CLOUD_COVER', 'less_than', 60)

    # save_res = 15

    # save_folder = GID + '_Landsat-8'
    # command="mkdir "+save_folder
    # os.system(command)
    # count=filteredCollection.size().getInfo()
    # print("count is %d"%(count))
    # if count==0:
    #     print("there is no image for %s Sentinel-1A"%(GID))
    # else:

        # filtered_list=filteredCollection.toList(filteredCollection.size())

        # for i in range(filtered_list.size().getInfo()):
        #     image=ee.Image(filtered_list.get(i)).clip(geometry)
        #     fname = image.get('system:id').getInfo().split('/')[-1]
        #     # print(fname)
        #     print("downloading %s"%fname)
        #     url = image.getDownloadURL()
        #     # print(url)
        #     r=requests.get(url)
        #     name='./'+save_folder+'/'+'data.zip'
        #     path='./'+save_folder
        #     print(name)
        #     with open(name, 'wb') as f:
        #             f.write(r.content)
        #     try:

        #         with zipfile.ZipFile(name) as f:
        #             files = f.namelist()
        #             f.extractall(path)
        #         os.remove(name)
        #     except zipfile.BadZipFile:
        #         print('Skipping - Not a valid ZIP file')
        #     except Exception as e:
        #         print('Error extracting')











#     ###download Sentinel-1_D
    product = 'COPERNICUS/S1_GRD'
    filteredCollection = ee.ImageCollection(product).filterBounds(geometry).filterDate(start, end).filter(
        ee.Filter.eq('instrumentMode', 'IW')).filter(ee.Filter.eq('resolution', 'H')).filter(
        ee.Filter.eq('orbitProperties_pass', 'DESCENDING')).filter(
        ee.Filter.listContains('transmitterReceiverPolarisation', 'HH')).select('HH')

    save_res = 10
    save_folder = GID + '_Sentinel-1_D'

    command="mkdir "+save_folder
    os.system(command)
    count=filteredCollection.size().getInfo()
    print("count is %d"%(count))
    if count==0:
        print("there is no image for %s Sentinel-1D"%(GID))
    else:


        filtered_list=filteredCollection.toList(filteredCollection.size())

        for i in range(filtered_list.size().getInfo()):
            image=ee.Image(filtered_list.get(i)).clip(geometry)
            fname = image.get('system:id').getInfo().split('/')[-1]
            # print(fname)
            print("downloading %s"%fname)
            url = image.getDownloadURL()
            # print(url)
            r=requests.get(url)
            name='./'+save_folder+'/'+'data.zip'
            path='./'+save_folder
            print(name)
            with open(name, 'wb') as f:
                    f.write(r.content)
            try:

                with zipfile.ZipFile(name) as f:
                    files = f.namelist()
                    f.extractall(path)
                os.remove(name)
            except zipfile.BadZipFile:
                print('Skipping - Not a valid ZIP file')
            except Exception as e:
                print('Error extracting')







   ###download Sentinel-1_A
    product = 'COPERNICUS/S1_GRD'
    filteredCollection = ee.ImageCollection(product).filterBounds(geometry).filterDate(start, end).filter(
        ee.Filter.eq('instrumentMode', 'IW')).filter(ee.Filter.eq('resolution', 'H')).filter(
        ee.Filter.eq('orbitProperties_pass', 'ASCENDING')).filter(
        ee.Filter.listContains('transmitterReceiverPolarisation', 'HH')).select('HH')

    save_res = 10
    save_folder = GID + '_Sentinel-1_A'
    command="mkdir "+save_folder
    os.system(command)


    count=filteredCollection.size().getInfo()
    print("count is %d"%(count))
    if count==0:
        print("there is no image for %s Sentinel-1A"%(GID))
    else:
        filtered_list=filteredCollection.toList(filteredCollection.size())

        for i in range(filtered_list.size().getInfo()):
            image=ee.Image(filtered_list.get(i)).clip(geometry)
            fname = image.get('system:id').getInfo().split('/')[-1]
            # print(fname)
            print("downloading %s"%fname)
            url = image.getDownloadURL()
            # print(url)
            r=requests.get(url)
            name='./'+save_folder+'/'+'data.zip'
            path='./'+save_folder
            print(name)
            with open(name, 'wb') as f:
                    f.write(r.content)
            try:

                with zipfile.ZipFile(name) as f:
                    files = f.namelist()
                    f.extractall(path)
                os.remove(name)
            except zipfile.BadZipFile:
                print('Skipping - Not a valid ZIP file')
            except Exception as e:
                print('Error extracting')





    
    ###download Sentinel-2
    sel_bands = ['B4']
    data_product = 'COPERNICUS/S2'
    filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
        sel_bands).filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 60))
    save_res = 10
    save_folder = GID + '_Sentinel-2'

    command="mkdir "+save_folder
    os.system(command)

    count=filteredCollection.size().getInfo()
    print("count is %d"%(count))
    if count==0:
        print("there is no image for %s Sentinel-2"%(GID))
    else:

        filtered_list=filteredCollection.toList(filteredCollection.size())

        for i in range(filtered_list.size().getInfo()):
            image=ee.Image(filtered_list.get(i)).clip(geometry)
            fname = image.get('system:id').getInfo().split('/')[-1]
            # print(fname)
            print("downloading %s"%fname)
            url = image.getDownloadURL()
            # print(url)
            r=requests.get(url)
            name='./'+save_folder+'/'+'data.zip'
            path='./'+save_folder
            print(name)
            with open(name, 'wb') as f:
                    f.write(r.content)
            try:

                with zipfile.ZipFile(name) as f:
                    files = f.namelist()
                    f.extractall(path)
                os.remove(name)
            except zipfile.BadZipFile:
                print('Skipping - Not a valid ZIP file')
            except Exception as e:
                print('Error extracting')

