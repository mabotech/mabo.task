#

ALL: ;

build:
	pyinstaller --onefile --icon=app.ico dyno_bep.py 
	
redis
	pyinstaller --onefile --icon=app.ico listener_redis.py 
	    
build_d:
	pyinstaller --onefile dyno_bep.py
    
mon:
	nodemon --exec "c:/python27/python.exe" dyno_bep


.PHONY: build