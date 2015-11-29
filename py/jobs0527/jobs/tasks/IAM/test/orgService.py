# -*- coding: utf-8 -*-

"""
IAMService
"""
import time

import xml.sax.saxutils as saxutils

# post xml soap message

import sys, httplib

from lxml import etree
from cStringIO import StringIO

#import static

import toml


class IAMClient(object):
    
    def __init__(self):
        
        conf_fn = "config.toml"
        
        with open(conf_fn) as conf_fh:
        
            self.conf = toml.loads(conf_fh.read())
            

        print(self.conf)

    def searchAll(self, startPage, pageSize ):
        
        #config = static.ERP_CONFIG #'SL 8.0'
        
        query = {"username":self.conf["Admin"],"password":self.conf["Admin_Password"], "nonce":self.conf["Nonce"], "startPage":startPage, "pageSize": pageSize}
        
        
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
        
        host =self.conf["HOST"]
        print(host)
        webservice = httplib.HTTP(host)
        
        service = self.conf["Service2"]
        
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
        print "Response: ", statuscode, statusmessage, startPage
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

def main():
    
    cm = IAMClient()
    
    fh = open("id3.csv","w")
    
    for i in range(1, 20):
    
        xmlstr = cm.searchAll(i,10)
        
        string_file = StringIO(xmlstr.replace('soap:','').replace("ns2:",""))
        
        

        #root = etree.fromstring(xml)
        tree = etree.parse(string_file)
        
        

        resp = None
        
        

        for element in tree.xpath('/Envelope/Body/searchAllResponse/return/userData'):
            #resp = element[0][1].text
            #print "\n"
            v1 = get_element_text(element, "cn")
            
            v2 = get_element_text(element, "mail")

            v3 = get_element_text(element, "fotonAppAtt37")

            v4 = get_element_text(element, "mobile")
     
            v5 = get_element_text(element, "telephoneNumber")

            v6 = get_element_text(element, "uid")

            v7 = get_element_text(element, "ou")
            #print userPassword[0].text,
            
            
            x = "%s,%s,%s,%s,%s,%s,%s\n" % (v1, v2, v3, v4, v5, v6, v7)
            
            fh.write(x)
            
        time.sleep(0.5)
        

    fh.close()    
    
    """
    
    token = cm.parseSessionToken(xmlstr)

    rtn = cm.callMethod(token, "")
    
    print cm.getResult(rtn)
    

    """
 
    
if __name__ == '__main__':
    main()
