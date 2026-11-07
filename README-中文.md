# PUI 小米原生安装器切换 Hook · v6（实验性源码工程）

## 交付状态

这是一个可以通过 GitHub Actions 尝试构建 LSPosed APK 的源码工程；不是可以刷入的 KernelSU ZIP。未经 Android 17 实机验证。

## 功能

- 参考 HyperCeiler 固定提交 a41e309e6 中的 UseAndroidPackageInstaller 功能。
- 仅识别 Xiaomi / Redmi / POCO，SDK 34–37。
- 系统框架作用域：android（system_server）。
- 校验三个安装器路由方法和 isCTS 存在后再 Hook。
- 发生异常时尝试解除部分 Hook。
- 未做 ART deoptimization，部分系统可能无法生效。
- 未修改或打包 PUI 原版 APK，也不禁用系统安装器。

## 构建

进入 GitHub 仓库 Actions → Build experimental LSPosed APK → Run workflow，构建成功后下载 APK 构建产物。

## 手机检测

将 tools/inspect-device.sh 传到手机，以 Root 终端运行：

    su
    sh /sdcard/Download/inspect-device.sh

脚本只读取设备和安装器状态，不更改系统。

## 风险

PUI 3.6.25 包名为 com.android.packageinstaller；此前在小米 17 Pro HyperOS 4 / Android 17 的检测中，原生 AOSP 安装器未注册。单纯启用系统路由 Hook 不会自动安装或注册 PUI，也不能解决原 APK 的签名或特权权限要求。

请勿同时启用 HyperCeiler 的同名功能、NativeInstallerFix 和本 Hook；请勿禁用 com.miui.packageinstaller。若遇到安装异常，禁用本 LSPosed 模块并重启。使用 system_server Hook 前需确保存在安全恢复途径。

## 许可证与署名

原路由 Hook 思路和代码参考 HyperCeiler Contributors，AGPL-3.0-or-later。独立移植与测试封装：Gyziel。原版 PUI APK 作者：天伞桜 & PanL；原 APK 未随仓库分发。详细来源见 NOTICE.txt。

完整源码不等于已完成小米所有机型适配。后续还需验证 Android 17、ART 内联、包注册、签名、特权权限和 APK 安装会话。
