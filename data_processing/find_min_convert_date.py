import numpy as np

import argparse
import datetime

def convert_time(date):
    date=str(date)
    year=int(date[0:4])
    month=int(date[4:6])
    day=int(date[6:8])
    d1 = datetime.datetime(year,month,day)
    d2=datetime.datetime(year,1,1)
    intervel=d1-d2
    out_date=year+(intervel.days)/365.25
    return out_date

parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='absolute path of input shape')
parser.add_argument('--date',type=str,help='date of the terminus')
args = parser.parse_args()

data=np.loadtxt(args.input)
date=convert_time(args.date)
min=np.min(data)
print("%f %f"%(min,date))
