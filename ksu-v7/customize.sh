#!/system/bin/sh
ui_print '- PUI Xiaomi v7 SAFE PREFLIGHT'
touch "$MODPATH/skip_mount" || abort '- Cannot enforce no mount'
vendor="$(getprop ro.product.manufacturer) $(getprop ro.product.brand)"
case "$(echo "$vendor" | tr '[:upper:]' '[:lower:]')" in
  *xiaomi*|*redmi*|*poco*) ;;
  *) abort '- Not Xiaomi/Redmi/POCO';;
esac
sdk="$(getprop ro.build.version.sdk)"
case "$sdk" in 34|35|36|37) ;; *) abort "- Unsupported SDK $sdk";; esac
[ -f "$MODPATH/payload/PackageInstaller.apk" ] || abort '- PUI original APK missing'
expected='0a6f120bf28a3e9ed85beb93ecb09d9a18d63d4b040c30ac7c600ce7c72f9e51'
actual="$(sha256sum "$MODPATH/payload/PackageInstaller.apk" 2>/dev/null | cut -d ' ' -f 1)"
[ "$actual" = "$expected" ] || abort '- PUI original APK checksum mismatch'
ui_print '- Verified; no system mount, LSPosed hook or APK installation'
ui_print '- Click KernelSU Action to inspect installer registration and routing'
