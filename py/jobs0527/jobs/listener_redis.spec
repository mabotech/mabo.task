# -*- mode: python -*-
a = Analysis(['listener_redis.py'],
             pathex=['C:\\Mabo\\0507\\jobs'],
             hiddenimports=[],
             hookspath=None,
             runtime_hooks=None)
pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='listener_redis.exe',
          debug=False,
          strip=None,
          upx=True,
          console=True , icon='app.ico')
