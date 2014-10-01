# -*- encoding: utf-8 -*-



import os


import glob

import subprocess

import time

#print dir(os.path)

#print os.path.abspath()

rst_files = glob.glob('BP_SO_Pallet_Add_Tray*.rst')


for rst in rst_files:
   
    fn = rst.replace('.rst','')
   
    cmd = "C:\\Python27\\python C:\\Python27\\Scripts\\rst2odt.py %s.rst  %s.odt" %(fn,fn)
    print cmd
    subprocess.Popen(cmd, shell=True)


    time.sleep(3)
    
    cmd = "E:\\tools\\abiword\\bin\\abiword --to=docx  %s.odt" %(fn)
    print cmd
   
    print "\n"
    #subprocess.Popen(cmd, shell=True)    
    
