# -*- coding: utf-8 -*-

import os
import time

import hashlib

import requests

import csv
import json

import logbook

from config import Config

from singleton import Singleton

from maillib import Email

cfg = Config()

conf = cfg.get_conf()

logger = logbook.Logger("work")

class Notifier(object):
    
    __metacass__ = Singleton

    def __init__(self):
        self.data_file = conf["app"]["data_file"]
        print self.data_file
        
    def get_site_digest(self, url):
        
        req = requests.get(url)

        md5 = hashlib.md5()

        text = req.text

        md5.update(text)

        digest = md5.hexdigest()
        logger.debug(digest)
        return digest

    def save_data(self, data):
        
        with open(self.data_file,"wb") as fh:
            json_str = json.dumps(data, encoding="utf-8", sort_keys=True, indent=4)
            fh.write(json_str)
            
    def send_mail(self, changed_sites):
        
        with open(conf["app"]["maillist"], 'rb') as fh:
            
            reader = csv.reader(fh)

            for row in reader:            
                   
                title = row[0]
                email = row[1]    

                sendmail = Email(conf)            
                sendmail.send(email, title, changed_sites)    
    
    def work(self):
        
        logger.debug("working")
        print("working")
        
        fh = open(self.data_file,"rb")

        json_str = fh.read()
        
        fh.close()
        
        notify = False   
        
        changed_sites = []

        data = json.loads(json_str)
        
        for site in data["sites"]:
            
            url = site["url"]
            
            digest = self.get_site_digest(url)
            
            if digest != site["hash"]:
                site["hash"]= digest
                notify = True
                changed_sites.append(site)
        
        if notify == True:           
            
            logger.debug("send mail")
            self.send_mail(changed_sites)
            self.save_data(data)
        

    
if __name__ == "__main__":
    notifier = Notifier()
    notifier.work()

