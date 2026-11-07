#!/usr/bin/env python3
"""Static evidence only; does not patch/install the original PUI."""
import zipfile, sys, hashlib
if len(sys.argv)!=2:
    raise SystemExit('Usage: python tools/check-pui-original.py 安装器_3.6.25.apk')
p=sys.argv[1]
with zipfile.ZipFile(p) as z:
    want={'META-INF/xposed/java_init.list','META-INF/xposed/module.prop','META-INF/xposed/scope.list'}
    missing=want-set(z.namelist())
    if missing: raise SystemExit('Missing Xposed metadata: '+repr(missing))
    for f in sorted(want): print(f, '\n', z.read(f).decode(errors='replace').strip())
with open(p,'rb') as f: print('SHA256',hashlib.file_digest(f,'sha256').hexdigest())
print('NO APK MODIFICATION. Xposed metadata does not prove system privileges or compatibility.')
