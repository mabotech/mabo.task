# -*- coding: utf-8 -*-

"""
IAMService
"""

import os, sys

import time
import json

import xml.sax.saxutils as saxutils

# post xml soap message

import httplib

import requests

from lxml import etree
from cStringIO import StringIO

#import static

import toml

conf_fn = os.sep.join([os.path.split(os.path.realpath(__file__))[0],"config.toml"])

print conf_fn

with open(conf_fn) as conf_fh:

    conf = toml.loads(conf_fh.read())["app"]
    

#print(conf)

#exit(0)

class IAMClient(object):
    
    def __init__(self):
        
        pass

    def searchAll(self, startPage, pageSize ):
        
        #config = static.ERP_CONFIG #'SL 8.0'
        
        query = {"username":conf["Admin"],"password":conf["Admin_Password"], "nonce":conf["Nonce"], "startPage":startPage, "pageSize": pageSize}
        
        
        SM_TEMPLATE = r"""<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sear="http://search.service.iam.foton.com/">
       <soapenv:Header>

      <wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">

         <wsse:UsernameToken wsu:Id="UsernameToken-1" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">

            <wsse:Username>%(username)s</wsse:Username>

            <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">%(password)s</wsse:Password>

            <wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">%(nonce)s</wsse:Nonce>

            <wsu:Created>2012-07-06T01:49:02.953Z</wsu:Created>

         </wsse:UsernameToken>

      </wsse:Security>

   </soapenv:Header>
   <soapenv:Body>
      <sear:searchAll>
         <arg0>%(startPage)s</arg0>
         <arg1>%(pageSize)s</arg1>
         <!--Optional:-->
         <arg2>ou</arg2>
         <arg3>true</arg3>
      </sear:searchAll>
   </soapenv:Body>
</soapenv:Envelope>"""  % query

        SoapMessage = SM_TEMPLATE

        #print SoapMessage
        #construct and send the header
        
        host =conf["HOST"]
        #print(host)
        webservice = httplib.HTTP(host)
        
        service = conf["Service2"]
        
        url = "/IAMService/services/soap/%s" %(service)
        
        webservice.putrequest("POST", url)
        webservice.putheader("Host", host)
        webservice.putheader("User-Agent", "Mozilla/4.0+(compatible;+MSIE+6.0;+Windows+NT+5.2;+SV1;+.NET+CLR+1.1.4322)")
        webservice.putheader("Content-type", "text/xml; charset=\"UTF-8\"")
        webservice.putheader("Accept-Language", "en-us")
        webservice.putheader("Content-length", "%d" % len(SoapMessage))
        #webservice.putheader("SOAPAction", "authenticate")
        webservice.endheaders()
        webservice.send(SoapMessage)

        # get the response

        statuscode, statusmessage, header = webservice.getreply()
        #print "Response: ", statuscode, statusmessage, startPage
        #print "headers: ", header
        #print dir(webservice)
        res = webservice.getfile().read()
        
        fn = "%d.xml" %(time.time())
        #print res
        #with open(fn, 'w') as fh:
        #    fh.write(res)
            
        return  res #self.parseSessionToken(res)
    
    

    
    def getResponse(self, xmlstr):
        
        
        
        string_file = StringIO(xmlstr.replace('soap:',''))

        #root = etree.fromstring(xml)
        tree = etree.parse(string_file)

        resp = None

        for element in tree.xpath('/Envelope/Body'):
            resp = element[0][1].text
            
        return resp
        
    def getResult(self, xmlstr):
        
        #print xmlstr
        
        resp = self.getResponse(xmlstr)
        
        string_file = StringIO(resp)

        #root = etree.fromstring(xml)
        tree = etree.parse(string_file)

        result = None
        
        v = tree.xpath('/Parameters')[0]
        
        l = len(v)
        
        result = v[l-1].text
        
        if result.count('successful') >0:
            return "S"
        else:
            return "F"    

def get_element_text(element, node):
    
    v = element.xpath(node)
    
    if len(v)>0:
        #print v[0].text.encode("utf8")
        return v[0].text.encode("utf8")
    else:
        return ""
        

def post(data):
    
    #print data

    URL =  conf["JSONRPC"] #'http://127.0.0.1:6226/api/v1/callproc.call'
    
    #mtp_update_equipemnt_cs1
    payload = {
                "jsonrpc":"2.0",
                "id":"r2",
                "method":"call",
                "params":
                {
                    "method":"mtp_upsert_cs11",
                    "table":"employee", 
                    "pkey":"uid",
                    "columns":data,
                   "context":{"user":"mt", "languageid":"1033", "sessionid":"123" } 
               }
            }
            
    HEADERS = {'content-type': 'application/json', 'accept':'json','User-Agent':'mabo'}
    #headers = HEADERS
    #headers = {'Accept':'json'}
    payload = json.dumps(payload)

    r = requests.post(URL, data = payload , headers=HEADERS)
    
    #print  r.headers
    
    #print r.text.encode("utf8")
    #v = json.loads(r.text)
        
def get_info(xmlstr):
    
        
        string_file = StringIO(xmlstr.replace('soap:','').replace("ns2:",""))
        
        #print string_file.read()

        #root = etree.fromstring(xml)
        tree = etree.parse(string_file)
        
        

        resp = None
        
        for element in tree.xpath('/Envelope/Body/searchAllResponse/return'):
            
            v1 = get_element_text(element, "code")
            
            if v1 == "failure":
                
                raise(Exception("failure"))
            
            v2 = get_element_text(element, "countSize")
            
            v3 = get_element_text(element, "message")
            
            #print v1, v2, v3

        for element in tree.xpath('/Envelope/Body/searchAllResponse/return/userData'):
            #resp = element[0][1].text
            #print "\n"
            data = {}
            
            for ele in conf["userData"]:
                """
                v1 = get_element_text(element, "cn")
            
                v2 = get_element_text(element, "mail")

                v3 = get_element_text(element, "fotonAppAtt37")

                v4 = get_element_text(element, "mobile")
         
                v5 = get_element_text(element, "telephoneNumber")

                v6 = get_element_text(element, "uid")

                v7 = get_element_text(element, "ou")
                #print userPassword[0].text,
                """
                
                data[ele] = get_element_text(element, conf["userData"][ ele ])
            
            
            #x = "%s,%s,%s,%s,%s,%s,%s\n" % (v1, v2, v3, v4, v5, v6, v7)
            
            post(data)
    

def sync_account(**kv):
    
    
    
    cm = IAMClient()
    
    #fh = open("id3.csv","w")
    
    for i in range(1, conf["PAGE"]):
    
        xmlstr = cm.searchAll(i, conf["LIMIT"])
        
        #print xmlstr
        
        get_info(xmlstr)
            
        #fh.write(x)
            
        time.sleep(conf["sleep"])
        

    #fh.close()    
    
    """
    
    token = cm.parseSessionToken(xmlstr)

    rtn = cm.callMethod(token, "")
    
    print cm.getResult(rtn)
    

    """
 
    
if __name__ == '__main__':
    
    sync_account()
