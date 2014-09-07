

nssm install nsqlookupd nsqlookupd

nssm install nsqd nsqd --lookupd-tcp-address=127.0.0.1:4160

nssm install nsqadmin nsqadmin --lookupd-http-address=127.0.0.1:4161