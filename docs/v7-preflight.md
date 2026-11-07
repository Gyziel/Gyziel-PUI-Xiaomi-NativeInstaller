# v7：KernelSU 一键诊断阶段（不是 PUI 挂载正式版）

目标：先在实际 Xiaomi / Redmi / POCO 设备上核实 APK 安装器注册、系统路由、签名/权限，避免“识别机型成功”就直接替换系统安装器。

已为用户生成可从 KernelSU 安装的只读诊断 ZIP（附件不包含在公开仓库中，因为用户提供的 PUI APK 授权状态未确认）。

## 模块结构

- module.prop：明确实验阶段
- customize.sh：小米设备 / SDK 34–37 识别及原版 PUI SHA256 校验
- action.sh：点击 KernelSU Action 显示当前安装器状态
- tools/inspect.sh：**只读** `pm path` / `pm list packages -u` / `cmd package query-activities` / 目标权限
- skip_mount：禁止系统挂载
- payload/PackageInstaller.apk：仅用户本地测试包包含，**不会上传 GitHub**
- 无 system/、service.sh、sepolicy.rule 或后台任务

## 为什么需要分阶段

HyperCeiler `UseAndroidPackageInstaller` Hook 只影响 `system_server` 的安装器选择逻辑；不能自动注册 `com.android.packageinstaller`，不能授予 PUI 的 `INSTALL_PACKAGES` 权限。Android 特权权限使用分区匹配的 allowlist，并仍受签名与平台政策约束。

## 验证闸门

1. 确认系统已注册的小米安装器与可能存在的 AOSP 安装器。
2. 确认 HyperCeiler 原生路由是否生效（需要有选择器/日志的实机证据）。
3. 检查目标包名占用、PUI APK 原始签名和目标权限。
4. 测试非关键 APK 的正常安装会话。
5. 准备禁用模块的救援路径后，才可考虑系统挂载实验。

**禁止**直接禁用/卸载 `com.miui.packageinstaller` 或绕过权限与签名校验。没有上述验证不能宣称适配所有机型。

本诊断工具不会启用 LSPosed Hook，也不会改变系统安装器。