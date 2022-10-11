import argparse
import numpy as np
import datetime
parser = argparse.ArgumentParser()
parser.add_argument('--date', help="input date")
args = parser.parse_args()

def convert_time(date):
    date=str(date)
    year=int(date[0:4])
    month=int(date[4:6])
    day=int(date[6:8])
    d1 = datetime.datetime(year,month,day)
    d2=datetime.datetime(year,1,1)
    day=(d1-d2).days
    return year,day

if __name__=='__main__':
    year,day=convert_time(args.date)
    print("%s %s"%(year,day))
