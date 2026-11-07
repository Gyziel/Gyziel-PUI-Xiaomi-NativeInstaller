/*
 * Extracted concept from HyperCeiler UseAndroidPackageInstaller.java
 * HyperCeiler Contributors Copyright (C) 2023-2026; AGPL-3.0-or-later.
 * Source: https://github.com/ReChronoRain/HyperCeiler/blob/a41e309e6/library/libhook/src/main/java/com/sevtinge/hyperceiler/libhook/rules/systemframework/others/UseAndroidPackageInstaller.java
 * Modifications / independently wrapped LSPosed legacy bridge: Gyziel.
 *
 * WARNING: This is an experimental system_server hook and does NOT install PUI.
 * It should only be enabled on an already verified compatible ROM with a
 * working alternative installer route; never disable MIUI Package Installer.
 */
package dev.gyziel.pui.nativehook;

import android.os.Build;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public final class NativeInstallerHook implements IXposedHookLoadPackage {
    private static final String TAG = "PuiNativeRouteV6";
    private static final String CLASS_NAME = "com.android.server.pm.PackageManagerServiceImpl";
    private static final String[] ROUTES = {
        "hookChooseBestActivity", "updateDefaultPkgInstallerLocked", "assertValidApkAndInstaller"
    };

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lp) {
        if (!"android".equals(lp.packageName)) return;
        if (!HookPolicy.supportedDevice(Build.MANUFACTURER, Build.BRAND, Build.VERSION.SDK_INT)) {
            XposedBridge.log(TAG + ": Unsupported ROM/SDK, no hook");
            return;
        }
        List<XC_MethodHook.Unhook> installed = new ArrayList<>();
        try {
            Class<?> pms = XposedHelpers.findClassIfExists(CLASS_NAME, lp.classLoader);
            if (pms == null) {
                XposedBridge.log(TAG + ": Missing Xiaomi PMS class; no hook");
                return;
            }
            Method cts = null;
            List<Method> routeMethods = new ArrayList<>();
            boolean[] found = new boolean[ROUTES.length];
            for (Method m : pms.getDeclaredMethods()) {
                if ("isCTS".equals(m.getName()) &&
                        m.getReturnType() == boolean.class && m.getParameterTypes().length == 0) {
                    cts = m;
                }
                for (int i = 0; i < ROUTES.length; i++) {
                    if (ROUTES[i].equals(m.getName())) {
                        found[i] = true;
                        routeMethods.add(m);
                        break;
                    }
                }
            }
            if (cts == null) {
                XposedBridge.log(TAG + ": isCTS boolean() absent; no hook");
                return;
            }
            for (int i = 0; i < found.length; i++) {
                if (!found[i]) {
                    XposedBridge.log(TAG + ": Missing " + ROUTES[i] + "; no partial hook");
                    return;
                }
            }
            // Register only when ALL required entry points are present.
            for (Method m : routeMethods) {
                installed.add(XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override protected void beforeHookedMethod(MethodHookParam param) {
                        ThreadScopedSwitch.enter();
                    }
                    @Override protected void afterHookedMethod(MethodHookParam param) {
                        ThreadScopedSwitch.exit();
                    }
                }));
            }
            installed.add(XposedBridge.hookMethod(cts, new XC_MethodHook() {
                @Override protected void beforeHookedMethod(MethodHookParam param) {
                    if (ThreadScopedSwitch.active()) param.setResult(true);
                }
            }));
            XposedBridge.log(TAG + ": Hooked " + routeMethods.size() +
                    " routing methods plus isCTS. PUI not installed; ART deopt not performed.");
        } catch (Throwable t) {
            // Never leave partially installed callbacks after an init failure.
            for (int i = installed.size() - 1; i >= 0; i--) {
                try { installed.get(i).unhook(); } catch (Throwable ignored) { }
            }
            XposedBridge.log(TAG + ": Failed, hooks rolled back (if runtime permits)");
            XposedBridge.log(t);
        }
    }
}
