# -*- coding: utf-8 -*-

"""
lxml objectify
"""

from lxml import etree
from lxml import objectify

def main():
    
    fn = "data/t1.xml"
    
    tree = objectify.parse(fn)    
  
    for e in tree.iter():
        try:
            if e.tag == "userData":
                print "=="*20
            else:
                print e.tag, e.text.encode("utf8")
        except Exception as exc:
            print exc
    
if __name__ == '__main__':
    main()
