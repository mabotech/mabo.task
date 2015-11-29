# -*- coding: utf-8 -*-
import os
import time

import subprocess

import json
import shutil
import datetime
from time import strftime, localtime

import toml
import requests

import csv

import data_gen



conf_fn = os.sep.join(
    [os.path.split(os.path.realpath(__file__))[0], "graphs.toml"])

# print conf_fn

with open(conf_fn) as conf_fh:

    cfg = toml.loads(conf_fh.read())

    conf = cfg["app"]
    
print conf

def execute(script):
    
    # config
    
    start = time.time()
    
    rscript = conf["RSCRIPT"]
    
    base = conf["BASE"]
    
    cmd = '%s --verbose "%s\\%s"' % (rscript, base, script)    

    proc1 = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)

    msg = proc1.communicate()[0]

    #print( msg ) 
    
    #print time.time() - start
  
  
def csv_gen(report):  
    
    # write csv   
    
    func =  getattr(data_gen, report)
    
    func(conf)

def task(report):
    
    reports = conf["reports"]#{"month":"one_month.R"}
    
    #print reports
    
    script = reports[report]
    
    #print script
    
    csv_gen(report)
    
    execute(script)
    
    
if __name__ == "__main__":
    
    task("task_count")
    task("bullet_UR")
    task("bullet_AR")
    task("monthlyWorktime")
    task("yearlyU")
    task("monthlyU")
    
    