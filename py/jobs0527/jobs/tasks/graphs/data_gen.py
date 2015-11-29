
from time import strftime, localtime

import csv
import datetime
import json

import requests


def get_prev_month():
    
    today = datetime.date.today()
    first = datetime.date(day=1, month=today.month, year=today.year)
    lastMonth = first - datetime.timedelta(days=1)
    
    return (int(lastMonth.strftime("%Y")), int(lastMonth.strftime("%m") ) )

def get_data(conf, method, year_month, type=""):

    
    
    #print year_month
    
    
    URL = conf["JSONRPC"]

    payload = {
        "jsonrpc": "2.0",
        "id": "r2",
        "method": "call",
        "params": {
            "method": method,
            "month":year_month,
            "type":type,
            "context": {
                "user": "mt",
                "languageid": "1033",
                "sessionid": "123"}}}

    HEADERS = {
        'content-type': 'application/json',
        'accept': 'json',
        'User-Agent': 'mabo'}

    payload = json.dumps(payload)
    
    print payload
    
    resp = requests.post(URL, data=payload, headers=HEADERS)

    s = resp.text  # .encode("utf8")
    
    #print s.encode("utf-8")
    
    v = json.loads(s)
    
    return v["retuning"]


def monthlyU(conf):
    
    method = conf["methods"]["monthlyU"]
    
    (year,month) = get_prev_month()
    year_month = "%s-%02d" % (year, month)
    
    data = get_data(conf, method, year_month)
    
    with open('monthlyU.csv', 'wb') as csvfile:
    
        csvwriter = csv.writer(csvfile, delimiter=',',
                                quotechar='"', quoting=csv.QUOTE_MINIMAL)
                                
        csvwriter.writerow(["id","plan", "util"])
        i = 0
        for row in data:
            i = i + 1
            #print '"%s",' %( row["equipname"].encode("utf8") )
            csvwriter.writerow([i,95, 100 * row["kpi1"]])


def monthlyWorktime(conf):
    
    method = conf["methods"]["monthlyU"]
    
    (year,month) = get_prev_month()
    year_month = "%s-%02d" % (year, month)
    
    data = get_data(conf, method, year_month)
    
    with open('monthlyWorktime.csv', 'wb') as csvfile:
    
        csvwriter = csv.writer(csvfile, delimiter=',',
                                quotechar='"', quoting=csv.QUOTE_MINIMAL)
                                
        csvwriter.writerow(["id","plan", "work"])
        i = 0
        for row in data:
            i = i + 1
            print '"%s",' %( row["equipname"].encode("utf8") )
            csvwriter.writerow([i,row["plantime"],row["worktime"]])
            
        
        
   
def yearlyU(conf):
    
    method = conf["methods"]["yearlyU"]
    
    (year,month) = get_prev_month()
    year_month = "%s-%02d" % (year, month)
    
    data = get_data(conf, method, year_month)
    
    with open('yearlyU.csv', 'wb') as csvfile:
    
        csvwriter = csv.writer(csvfile, delimiter=',',
                                quotechar='"', quoting=csv.QUOTE_MINIMAL)
                                
        csvwriter.writerow(["month","variable","value"])
        
        i = 0
        m = 0
        for row in data:
            #print row
            m = row["month_"]
            
            if i == 0:
                if m != 1:
                    pass
                    #csvwriter.writerow([1,"lab1",0])
            
            csvwriter.writerow([row["month_"],row["labid"], 100 * row["kpi_value"]])
            
            i = i +1
            
        if m != 12:
            pass
            #csvwriter.writerow([12,"lab1",0])
            
            

def bullet_UR(conf):
    
    
   
    method = conf["methods"]["bullet_UR"]
    #method = "mtp_get_task_count"
    year_month = strftime("%Y-%m", localtime())
    
    data = get_data(conf, method, year_month,"U")
    
    #print data
    
    with open('bullet_UR.csv', 'wb') as csvfile:
    
        csvwriter = csv.writer(csvfile, delimiter=',',
                                quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csvwriter.writerow(["high","mean","low","target","value"])
        
        i = 0
        for row in data:
            i = i + 1
            print row
            csvwriter.writerow([row["useratemax"],row["userate"],row["useratemin"],row["userate"], row["rate"]])
            #csvwriter.writerow([i,row["date_"],row["val1"],row["val2"],row["val3"],row["val4"]])

def bullet_AR(conf):
    
    
   
    method = conf["methods"]["bullet_AR"]
    #method = "mtp_get_task_count"
    year_month = strftime("%Y-%m", localtime())
    
    data = get_data(conf, method, year_month, "A")
    
    #print data
    
    with open('bullet_AR.csv', 'wb') as csvfile:
    
        csvwriter = csv.writer(csvfile, delimiter=',',
                                quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csvwriter.writerow(["high","mean","low","target","value"])
        
        i = 0
        for row in data:
            i = i + 1
            print i, row
            csvwriter.writerow([row["usableratemax"],row["usablerate"],row["usableratemin"],row["usablerate"], row["rate"]])

def task_count(conf):
    
    method = conf["methods"]["task_count"]
    #method = "mtp_get_task_count"
    
    year_month = strftime("%Y-%m", localtime())
    
    data = get_data(conf, method, year_month)
    
    #print data
    
    with open('task_count.csv', 'wb') as csvfile:
    
        csvwriter = csv.writer(csvfile, delimiter=',',
                                quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csvwriter.writerow(["Date","DateString","R1","R2","R3","R4"])
        
        i = 0
        for row in data:
            i = i + 1
            csvwriter.writerow([i,row["date_"],row["val1"],row["val2"],row["val3"],row["val4"]])
            
            
        tomorrow = "2015-05-04"
        
        csvwriter.writerow([4,tomorrow, 0,0,0,0])
        
        lastday =  "2015-05-31"
        csvwriter.writerow([31,lastday, 0,0,0,0])
        
        #csvwriter.writerow([1,2,3])
    
    
if __name__ == "__main__":
    
    import os
    
    import toml
    
    conf_fn = os.sep.join(
        [os.path.split(os.path.realpath(__file__))[0], "graphs.toml"])

    # print conf_fn

    with open(conf_fn) as conf_fh:

        cfg = toml.loads(conf_fh.read())

        conf = cfg["app"]
        
    #print conf
    
    #monthlyWorktime(conf)
    #monthlyU(conf)
    bullet_UR(conf)
    bullet_AR(conf)
    #yearlyU(conf)