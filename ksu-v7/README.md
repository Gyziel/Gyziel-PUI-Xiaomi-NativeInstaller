# PUI v7 KernelSU safe preflight module

本目录为可重复打包的模块源码。**只读诊断，不挂载 PUI、不启用 LSPosed，不修改原生小米安装器。**

用户提供的原始 `安装器_3.6.25.apk` **不公开分发**。本地构建时：
1. 把原版 APK 放进 `ksu-v7/payload/PackageInstaller.apk`；
2. 在 ZIP 根目录包含 `module.prop`、`customize.sh`、`action.sh`、`tools/inspect.sh`、`skip_mount`、`payload/PackageInstaller.apk`；
3. 用 KernelSU 安装 ZIP，点模块“操作/Action”显示注册及权限状态。
4. 把完整报告提供给开发者核对兼容问题，不要开启系统替换。

原版 PUI SHA-256: `0a6f120bf28a3e9ed85beb93ecb09d9a18d63d4b040c30ac7c600ce7c72f9e51`

此脚本和 `../tools/inspect-v7.sh` 配合。打包时将其复制到模块中的 `tools/inspect.sh`。

设备支持声明是**预检支持**，而非全小米实机兼容承诺。签名、特权安装权限、HyperOS 的安装器分派尚需设备测试。