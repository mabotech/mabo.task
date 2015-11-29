# -*- coding: utf-8 -*-

import hashlib

import base64


def encryptSHA(password):

    sha1digest = hashlib.sha1(password).digest()

    return "{SHA}%s" % (base64.b64encode(sha1digest) )    
    
def test():
    
    d = encryptSHA('Appsjgl')
    
    print d

    t = "{SHA}6/x5EAd3cMg0D2PNLcoqwfEgRE8="

    assert(t ==d)
    
if __name__ == "__main__":
    
    print base64.b64decode("+gyCOJlGPRu8sYOwP+D+Qw==")
    #print encryptSHA("zhaoqian")
    #print "{SHA}fWRzvSb5Q0khi9uSjCkSrvteN9s="
    test()