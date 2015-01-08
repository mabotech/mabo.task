# -*- coding: utf-8 -*-

import time
import calendar


import random

def main(year, month):   
    
    
    monthdays = calendar.Calendar(1).itermonthdays2(year, month)    
    print "Date DateString  F1  F2  F3  F4"
    for day in monthdays:
        #print day
        if day[0] > 0:
            
            t1 = random.randint(1,3)
            t2 = random.randint(6,10)
            t3 = random.randint(6,10)
            t4 = random.randint(6,10)
            date =  "%d-%02d-%02d" % (year, month, day[0]) 
            
            if day[1] == 0:
                t1 = t1/2
                t2 = t2/2
                t3 = t3/2
                t4 = t4/2
            elif day[1] in [5,6]:
                continue
            
            print "%s   %s   %s  %s  %s  %s" %(day[0], date, t1, t2, t3, t4)
            
            
            
            

if __name__ == "__main__":
    
    main(2014, 12)