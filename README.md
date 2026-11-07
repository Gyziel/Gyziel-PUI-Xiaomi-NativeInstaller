# PUI Xiaomi Native Installer Hook · v6

**Experimental standalone LSPosed Android package installer routing hook for Xiaomi / Redmi / POCO.**

This project extracts the **native installer selection concept** from [HyperCeiler](https://github.com/ReChronoRain/HyperCeiler) and packages it as a minimal independent LSPosed module.

- Android SDK 34–37 device preflight, Xiaomi / Redmi / POCO only.
- System Framework (`android`) scope only.
- The source **does not** install, mount, or bundle the original PUI APK.
- Do **not** disable `com.miui.packageinstaller`.
- **Not tested on Xiaomi 17 Pro HyperOS 4 / Android 17. Do not enable on primary phone without verified recovery.**

## Build

Open **Actions → Build experimental LSPosed APK**. On successful build, download the artifact `PUI-NativeRouter-v6-EXPERIMENTAL-APK`. This produces an **LSPosed APK**, not a flashable KernelSU ZIP.

For device diagnostics, run `tools/inspect-device.sh` in a root shell. It only reads information and changes nothing.

## Limitations and roadmap

Only installer *routing* Hook is implemented. The original PUI (`com.android.packageinstaller`) requires separate package registration, signature and privilege verification before it could substitute a system installer. ART deoptimization and compatibility testing are incomplete. No automated PUI mounting is implemented.

## Credits and licensing

- Original routing concept: HyperCeiler Contributors (2023–2026), licensed AGPL-3.0-or-later.
- Experimental independent adaptation and packaging: Gyziel.
- Original PUI authors: 天伞桜 & PanL (APK not redistributed here).
- See [NOTICE.txt](NOTICE.txt) and [LICENSE](LICENSE).

**Source is experimental; passing compilation does not imply device safety or functionality.**
