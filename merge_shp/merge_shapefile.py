import os
import shutil
import pandas as pd
import geopandas as gpd
import argparse
import pandas as pd


parser = argparse.ArgumentParser()
parser.add_argument('--input_shape', type=str, help='absolute path of input shape')
parser.add_argument('--output_shape', type=str, help='absolute path of output shape')
parser.add_argument('--date', type=str, help='absolute path of output shape')
parser.add_argument('--GID', type=str, help='absolute path of output shape')
parser.add_argument('--satellite', type=str, help='absolute path of output shape')
parser.add_argument('--uncertainty', type=str, help='uncertainty of terminus traces')
args = parser.parse_args()



shpfile = gpd.read_file(args.input_shape)['geometry']
shpfile2=gpd.GeoDataFrame(geometry=gpd.GeoSeries(shpfile))
pd_date = pd.to_datetime(args.date, format='%Y%m%d', errors='ignore')
shpfile2['Date']=str(pd_date.date())
shpfile2['Glacier ID'] =args.GID
shpfile2['Satellite']=args.satellite
shpfile2['Error']=args.uncertainty


#check if output file exist
if os.path.exists(args.output_shape):
    shpfiles = gpd.read_file(args.output_shape)
    combined = pd.concat([shpfiles,shpfile2], ignore_index=True)
else:
    combined = pd.concat([shpfile2], ignore_index=True)



combined.to_file(args.output_shape)
