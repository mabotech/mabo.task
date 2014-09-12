# -*- coding: utf-8 -*-

"""
Email lib
"""


from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage

import smtplib

from mako.template import Template
import logbook
logger = logbook.Logger("mail")

class Email(object):
    
    def __init__(self, conf):
        
        self.conf = conf
        
        self.subject = self.conf["mail"]["subject"]
        self.strFrom = self.conf["mail"]["mailFrom"]
        
        self.msgRoot = MIMEMultipart('related')
        self.msgRoot['Subject'] = self.subject
        self.msgRoot['From'] = self.strFrom
        self.msgRoot['BCC'] = self.conf["mail"]["mailBCC"]
        self.msgRoot.preamble = 'This is a multi-part message in MIME format.'
       
        self.msgAlternative = MIMEMultipart('alternative')
        self.msgRoot.attach(self.msgAlternative)      
        
    def attach_text(self, title, sites):
        
        plain_tpl = self.conf["app"]["text_template"]
        
        msgtemplate = Template(filename=plain_tpl, disable_unicode=True, input_encoding='utf-8')       
      
        text  =  msgtemplate.render(title=title, sites = sites)
        # text
        msgText = MIMEText(text,'plain', 'utf-8')
        self.msgAlternative.attach(msgText)        

        
    def attach_html(self, title, sites):
        
        
        rich_tpl = self.conf["app"]["html_template"]
        
        msgtemplate = Template(filename=rich_tpl, disable_unicode=True, input_encoding='utf-8')       
      
        html  =  msgtemplate.render(title=title, sites = sites)
        # html
        # We reference the image in the IMG SRC attribute by the ID we give it below
        msgText = MIMEText(html, 'html', 'utf-8')
        self.msgAlternative.attach(msgText)
        
    
    def make_msg(self, title, sites):


        self.attach_text(title, sites)
        
        self.attach_html(title, sites)

        
        return self.msgRoot.as_string()

    def send(self, strTo, title, sites):
        # Send the email (this example assumes SMTP authentication is required)
        
        self.msgRoot['To'] = strTo
        
        msg = self.make_msg(title, sites)
        
        #print(msg)
        
        host = self.conf["smtp"]["host"]
        user = self.conf["smtp"]["user"]
        password = self.conf["smtp"]["password"]
        
        smtp = smtplib.SMTP(host)
        

        #smtp.connect(host)
        #smtp.set_debuglevel(1)
        smtp.login(user, password)
        strTo = [strTo] + [self.conf["mail"]["mailBCC"]]
        smtp.sendmail(self.strFrom, strTo, msg)
        smtp.quit()
        logger.debug("[%s] sent" % (title) )