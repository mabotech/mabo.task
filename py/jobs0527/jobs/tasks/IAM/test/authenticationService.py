# -*- coding: utf-8 -*-

"""
IAMService
"""
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

    def getUserByUsername(self):
        
        #config = static.ERP_CONFIG #'SL 8.0'
        
        user = {"username":self.conf["username"], "password":self.conf["password"]}
        
        SM_TEMPLATE = r"""<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aut="http://authentication.service.iam.foton.com/">
<soapenv:Header/>
<soapenv:Body>
<aut:authenticate>
<arg0>
<principal>
<name>TEMS</name>
<type>application</type>
</principal>
</arg0> 
<arg1>
<parameter>
<name>LoginModuleName</name>
<value>LDAP-SIMPLE</value>
</parameter>
</arg1>
<arg2>
<credential>
<encode></encode>
<format></format>
<type>password</type>
<value>%(password)s</value>
</credential> 
<credential>
<encode></encode>
<format></format>
<type>username</type> 
<value>%(username)s</value>
</credential>
</arg2>
</aut:authenticate>
</soapenv:Body>
</soapenv:Envelope>""" % user

        SoapMessage = SM_TEMPLATE

        #print SoapMessage
        #construct and send the header
        
        host =self.conf["HOST"]
        webservice = httplib.HTTP(host)
        webservice.putrequest("POST", "/IAMService/services/soap/authenticationService")
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
        #print "Response: ", statuscode, statusmessage
        #print "headers: ", header
        
        res = webservice.getfile().read()
        
        print res
        
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


def main():
    
    cm = IAMClient()
    
    xmlstr = cm.getUserByUsername()
    
    """
    
    token = cm.parseSessionToken(xmlstr)

    rtn = cm.callMethod(token, "")
    
    print cm.getResult(rtn)
    

    """
 
    
if __name__ == '__main__':
    main()
