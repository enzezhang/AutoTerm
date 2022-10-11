import ee
ee.Authenticate()
ee.Initialize()
import geetools
import time


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


    #download Landsat-7

    start = ee.Date('1999-01-01')
    end = ee.Date('2014-01-01')
    sel_bands = ['B8']

    data_product = 'LANDSAT/LE07/C01/T1'

    filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
        sel_bands).filterMetadata('CLOUD_COVER', 'less_than', 60)

    save_res = 15

    save_folder = GID + '_Landsat-7'


    count = filteredCollection.size().getInfo()

    if count > 0:

        task = geetools.batch.Export.imagecollection.toDrive(
            collection=filteredCollection,
            folder=save_folder,
            scale=save_res,
            fileFormat='GeoTIFF',
            region=geometry,
            verbose=True,
            dataType='int16'
        )

    #download Landsat-5

    start = ee.Date('1984-01-01')
    end = ee.Date('2012-05-05')
    sel_bands = ['B3']

    data_product = 'LANDSAT/LT05/C01/T1'

    filteredCollection = ee.ImageCollection(data_product).filterBounds(geometry).filterDate(start, end).select(
        sel_bands).filterMetadata('CLOUD_COVER', 'less_than', 60)
    count=filteredCollection.size().getInfo()



    if count > 0:


        save_res = 30

        save_folder = GID + '_Landsat-5'



        task = geetools.batch.Export.imagecollection.toDrive(
            collection=filteredCollection,
            folder=save_folder,
            scale=save_res,
            fileFormat='GeoTIFF',
            region=geometry,
            verbose=True,
            dataType='int16'
        )
    line = f.readline()



f.close()
