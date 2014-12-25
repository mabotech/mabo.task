# -*- coding: utf-8 -*-

"""
send email with images
"""
import csv

from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage

from email.header import Header


import smtplib


from greeting_en import gen_image

import toml

import socket

import gevent

class Sendmail(object):
    
    def __init__(self, conf):
        
        self.conf = conf
        
        self.subject =  Header("Merry Xmas & Happy New Year!", "utf-8")
        self.strFrom = self.conf["mail"]["mailFrom"]
        
        self.msgRoot = MIMEMultipart('related')
        self.msgRoot['Subject'] = self.subject
        self.msgRoot['From'] = self.strFrom
        self.msgRoot['BCC'] = self.conf["mail"]["mailBCC"]
        self.msgRoot.preamble = 'This is a multi-part message in MIME format.'            
       
        # Create the root message and fill in the from, to, and subject headers
        
        # Encapsulate the plain and HTML versions of the message body in an
        # 'alternative' part, so message agents can decide which they want to display.        
        self.msgAlternative = MIMEMultipart('alternative')
        self.msgRoot.attach(self.msgAlternative)
        
        
    def attach_image(self, img):
        #image
        # This example assumes the image is in the current directory
        
        
        fp = open(img, 'rb')
        
        msgImage = MIMEImage(fp.read())
        
        fp.close()

        # Define the image's ID as referenced above
        msgImage.add_header('Content-ID', '<image1>')
        self.msgRoot.attach(msgImage)        
        
    def attach_text(self, title):
        
        text = """Dear %s,

Merry Xmas & Happy New Year!!

-- 
MA Jianjun  马建军
"""   % (title)
        # text
        msgText = MIMEText(text,'plain', 'utf-8')
        self.msgAlternative.attach(msgText)        

        
    def attach_html(self):
        
        
        html = '''<html>
        <body>
        <img src="cid:image1">
        <br>
-- <br>
MA Jianjun 马建军<br>
<br>
        
        </body>
        </html>'''
        # html
        # We reference the image in the IMG SRC attribute by the ID we give it below
        msgText = MIMEText(html, 'html', 'utf-8')
        self.msgAlternative.attach(msgText)
        
    
    def make_msg(self, title, img):


        self.attach_text(title)
        
        self.attach_html()

        self.attach_image(img)
        
        return self.msgRoot.as_string()

    def send(self, strTo, title, img):
        # Send the email (this example assumes SMTP authentication is required)

        
        self.msgRoot['To'] = strTo
        
        msg = self.make_msg(title, img)
        
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
        print "[%s] sent" % (title)
        
def main():


    conf_fn = "conf_en.toml"

    with open(conf_fn) as conf_fh:
        
        conf = toml.loads(conf_fh.read())


    with open(conf["app"]["csv"], 'rb') as fh:
        
        reader = csv.reader(fh)
        i = 0
        for row in reader:
            
            i = i +1
            
            if i > 1:
                pass
                #break
                
            title = row[0]

            img = gen_image(title.decode('utf-8'), conf)
            
            gevent.sleep(0.5)
            sendmail = Sendmail(conf)
            
            sendmail.send(row[1], title, img)
            print title, row[1]
            gevent.sleep(0.5)
            
            #print img
            #gen_image
    
if __name__ == '__main__':
        
    main()