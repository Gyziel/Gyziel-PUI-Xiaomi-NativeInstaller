#!/system/bin/sh
# PUI v7 read-only route check; does not install, mount or modify system.
prop() { getprop "$1" 2>/dev/null; }
path() { pm path "$1" 2>/dev/null | sed -n 's/^package://p' | head -1; }
known() { pm list packages -u "$1" 2>/dev/null | grep -Fx "package:$1" >/dev/null; }
showpkg() {
  pkg="$1"; label="$2"; p="$(path "$pkg")"
  if [ -n "$p" ]; then
    echo "$label: REGISTERED -> $p"
  elif known "$pkg"; then
    echo "$label: PRESENT_BUT_NOT_ACTIVE"
  else
    echo "$label: NOT_REGISTERED"
  fi
}
echo '=== PUI Xiaomi v7 preflight (READ ONLY) ==='
echo "Manufacturer/Brand: $(prop ro.product.manufacturer) / $(prop ro.product.brand)"
echo "Model/Device: $(prop ro.product.model) / $(prop ro.product.device)"
echo "OS: Android $(prop ro.build.version.release), SDK=$(prop ro.build.version.sdk), HyperOS=$(prop ro.mi.os.version.name)"
showpkg com.miui.packageinstaller MIUI_INSTALLER
showpkg com.android.packageinstaller AOSP_INSTALLER
showpkg com.google.android.packageinstaller GOOGLE_INSTALLER
showpkg dev.gyziel.pui.nativehook EXPERIMENTAL_HOOK
showpkg com.sevtinge.hyperceiler HYPERCEILER
echo '-- APK VIEW handlers --'
cmd package query-activities --brief -a android.intent.action.VIEW -t application/vnd.android.package-archive 2>&1 | head -24 || true
echo '-- INSTALL_PACKAGE handlers --'
cmd package query-activities --brief -a android.intent.action.INSTALL_PACKAGE -t application/vnd.android.package-archive 2>&1 | head -24 || true
echo '-- AOSP INSTALL_PACKAGES permission --'
if [ -n "$(path com.android.packageinstaller)" ]; then
  dumpsys package com.android.packageinstaller 2>/dev/null | grep -E 'android.permission.(INSTALL_PACKAGES|DELETE_PACKAGES|READ_INSTALL_SESSIONS): granted=' | head -10 || true
else
  echo 'NOT_CHECKED (AOSP installer not registered)'
fi
echo 'MOUNT_ALLOWED=NO; route/signature/permissions not verified on real device'
echo 'NO_ACTION_WAS_TAKEN'
