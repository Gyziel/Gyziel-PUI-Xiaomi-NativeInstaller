#!/system/bin/sh
# READ ONLY; no settings changed. Run with su for comprehensive package details.
echo '=== PUI Xiaomi native installer preflight v6 (READ ONLY) ==='
for key in ro.product.manufacturer ro.product.brand ro.product.model ro.product.device ro.build.version.sdk ro.build.version.release ro.mi.os.version.name ro.build.fingerprint; do
  printf '%s: ' "$key"; getprop "$key"
done
for pkg in com.miui.packageinstaller com.android.packageinstaller com.google.android.packageinstaller dev.gyziel.pui.nativehook com.sevtinge.hyperceiler; do
  echo "--- $pkg registered paths"
  pm path "$pkg" 2>&1 || true
  echo "--- $pkg in package registry"
  pm list packages -u "$pkg" 2>&1 | grep -F "$pkg" || true
done
echo '--- VIEW/APK handler (best effort)'
cmd package query-activities --brief -a android.intent.action.VIEW -t application/vnd.android.package-archive 2>&1 | head -30 || true
echo '--- AOSP package permissions (if present)'
dumpsys package com.android.packageinstaller 2>/dev/null | grep -E 'Package \[|codePath=|pkgFlags=|privateFlags=|INSTALL_PACKAGES|DELETE_PACKAGES|granted=' | head -50 || true
echo '=== This script made NO modifications ==='
