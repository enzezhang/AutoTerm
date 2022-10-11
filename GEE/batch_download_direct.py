import ee
import os
ee.Authenticate()
ee.Initialize()
import requests
import zipfile
import geetools
import time
start = ee.Date('2013-02-01')
end = ee.Date('2021-07-01')

f=open('Glacier_ID_list_download_1.txt')
line = f.readline()
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


    #download Landsat-8
    sel_bands = ['B8']

    data_product = 'LANDSAT/LC08/C01/T1'

    filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
        sel_bands).filterMetadata('CLOUD_COVER', 'less_than', 60)

    save_res = 15

    save_folder = GID + '_Landsat-8'
    command="mkdir "+save_folder
    os.system(command)

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
        with zipfile.ZipFile(name) as f:
            files = f.namelist()
            f.extractall(path)
        os.remove(name)


    # task = geetools.batch.Export.imagecollection.toDrive(
    #     collection=filteredCollection,
    #     folder=save_folder,
    #     scale=save_res,
    #     fileFormat='GeoTIFF',
    #     region=geometry,
    #     verbose=True,
    #     dataType='int16'
    # )








# #     ###download Sentinel-1_D
#     product = 'COPERNICUS/S1_GRD'
#     dataset = ee.ImageCollection(product).filterBounds(geometry).filterDate(start, end).filter(
# ee.Filter.eq('instrumentMode', 'IW')).filter(ee.Filter.eq('resolution', 'H')).filter(
#         ee.Filter.eq('orbitProperties_pass', 'DESCENDING')).filter(
#         ee.Filter.listContains('transmitterReceiverPolarisation', 'HH')).select('HH')

#     save_res = 10
#     save_folder = GID + '_Sentinel-1_D'
#     task = geetools.batch.Export.imagecollection.toDrive(
#         collection=dataset,
#         folder=save_folder,
#         scale=save_res,
#         fileFormat='GeoTIFF',
#         region=geometry,
#         verbose=True,
#         dataType='float'
#     )
#     print ("Start : %s" % time.ctime())
#     time.sleep(sleeptime)
#     print ("End : %s" % time.ctime())






#    ###download Sentinel-1_A
#     product = 'COPERNICUS/S1_GRD'
#     dataset = ee.ImageCollection(product).filterBounds(geometry).filterDate(start, end).filter(
#         ee.Filter.eq('instrumentMode', 'IW')).filter(ee.Filter.eq('resolution', 'H')).filter(
#         ee.Filter.eq('orbitProperties_pass', 'ASCENDING')).filter(
#         ee.Filter.listContains('transmitterReceiverPolarisation', 'HH')).select('HH')

#     save_res = 10
#     save_folder = GID + '_Sentinel-1_A'
#     task = geetools.batch.Export.imagecollection.toDrive(
#         collection=dataset,
#         folder=save_folder,
#         scale=save_res,
#         fileFormat='GeoTIFF',
#         region=geometry,
#         verbose=True,
#         dataType='float'
#     )
#     print ("Start : %s" % time.ctime())
#     time.sleep(sleeptime)
#     print ("End : %s" % time.ctime())




    
#     ###download Sentinel-2
#     sel_bands = ['B4']
#     data_product = 'COPERNICUS/S2'
#     filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
#         sel_bands).filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 60))
#     save_res = 10
#     save_folder = GID + '_Sentinel-2'
#     task = geetools.batch.Export.imagecollection.toDrive(
#         collection=filteredCollection,
#         folder=save_folder,
#         scale=save_res,
#         fileFormat='GeoTIFF',
#         region=geometry,
#         verbose=True,
#         dataType='int16'
#     )

    line = f.readline()
f.close()
