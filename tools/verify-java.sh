#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/stubs/android/os" "$tmp/stubs/de/robv/android/xposed/callbacks" "$tmp/stubs/de/robv/android/xposed" "$tmp/out"
cat > "$tmp/stubs/android/os/Build.java" <<'EOF'
package android.os;
public class Build {
 public static String MANUFACTURER="Xiaomi", BRAND="Xiaomi";
 public static class VERSION { public static int SDK_INT=37; }
}
EOF
cat > "$tmp/stubs/de/robv/android/xposed/IXposedHookLoadPackage.java" <<'EOF'
package de.robv.android.xposed;
public interface IXposedHookLoadPackage {
 void handleLoadPackage(de.robv.android.xposed.callbacks.XC_LoadPackage.LoadPackageParam param) throws Throwable;
}
EOF
cat > "$tmp/stubs/de/robv/android/xposed/XC_MethodHook.java" <<'EOF'
package de.robv.android.xposed;
public class XC_MethodHook {
 protected void beforeHookedMethod(MethodHookParam p) throws Throwable {}
 protected void afterHookedMethod(MethodHookParam p) throws Throwable {}
 public static class MethodHookParam { public void setResult(Object result){} }
 public class Unhook { public void unhook(){} }
}
EOF
cat > "$tmp/stubs/de/robv/android/xposed/XposedBridge.java" <<'EOF'
package de.robv.android.xposed;
import java.lang.reflect.Method;
public class XposedBridge {
 public static XC_MethodHook.Unhook hookMethod(Method m, XC_MethodHook h){return h.new Unhook();}
 public static void log(String s){} public static void log(Throwable t){}
}
EOF
cat > "$tmp/stubs/de/robv/android/xposed/XposedHelpers.java" <<'EOF'
package de.robv.android.xposed;
public class XposedHelpers {
 public static Class<?> findClassIfExists(String n,ClassLoader c){return null;}
}
EOF
cat > "$tmp/stubs/de/robv/android/xposed/callbacks/XC_LoadPackage.java" <<'EOF'
package de.robv.android.xposed.callbacks;
public class XC_LoadPackage {
 public static class LoadPackageParam {public String packageName;public ClassLoader classLoader;}
}
EOF
javac -encoding UTF-8 --release 17 -d "$tmp/out" \
 $(find "$tmp/stubs" app/src/main/java -name '*.java' -print)
cat > "$tmp/Test.java" <<'EOF'
import dev.gyziel.pui.nativehook.HookPolicy;
public class Test {
 public static void main(String[] args) {
  if(!HookPolicy.supportedDevice("Xiaomi","Redmi",37)) throw new AssertionError();
  if(!HookPolicy.supportedDevice("POCO","POCO",35)) throw new AssertionError();
  if(HookPolicy.supportedDevice("Samsung","Samsung",37)) throw new AssertionError();
  if(HookPolicy.supportedDevice("Xiaomi","Xiaomi",33)) throw new AssertionError();
  if(HookPolicy.supportedDevice("Xiaomi","Xiaomi",38)) throw new AssertionError();
  System.out.println("Pure Java policy tests passed");
 }
}
EOF
javac -encoding UTF-8 --release 17 -cp "$tmp/out" -d "$tmp/out" "$tmp/Test.java"
java -cp "$tmp/out" Test
echo 'JAVA SYNTAX VERIFIED WITH LOCAL STUBS - THIS IS NOT ANDROID APK COMPILATION'
