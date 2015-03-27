



for i in xrange(1,10):
    print "notify test, 'abc%s';" %(i)
    
    import toml

with open("config.toml") as conffile:
    config = toml.loads(conffile.read())
    print config['app']['channels']