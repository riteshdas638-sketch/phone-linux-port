# MT6763V Mobile Linux Port — Volla Phone X reference

This project now uses the **Volla Phone X (`yggdrasilx`)** as the closest public reference device, rather than the older Volla Phone (`yggdrasil`). The match is unusually close to the working assumptions supplied for the target: Helio P23 / MT6763V, eight Cortex-A53 cores, Mali-G71 MP2, 64 GB eMMC, and a 720 × 1560 screen.

## What exists already

The Volla Phone X has an established **Ubuntu Touch 20.04 (Focal)** port. The official UBports device page currently lists stable **20.04 OTA-12**, dated 2 June 2026, and describes the port as advanced support with the essential features working. It is based on Halium 10.0. This is a real, existing Linux mobile OS port for the Volla Phone X — not a new image built by this project.

Official device page: <https://devices.ubuntu-touch.io/device/yggdrasilx/>
Official installer: <https://ubports.com/ubports-installer>

## What this repository does

The included GitHub Actions workflow builds the **Volla Phone X vendor kernel reference** from the public HelloVolla source using the device's selected `gx290_defconfig`. It uploads the resulting kernel/DTB build outputs and logs as an artifact.

This is a **reference-kernel build**, not a complete Ubuntu Touch or postmarketOS install image, and not a flashable package for the target phone. It is designed to establish a reproducible kernel baseline that can be inspected and adapted once the target board details are known.

## Reference kernel facts checked from source

- Kernel source: `HelloVolla/android_kernel_volla_yggdrasilx`
- Kernel source branch: `volla-10.1`
- Pinned source commit: `dd40238e9fe086c38bad51b361bd9374b8254280`
- Kernel version in Makefile: **4.9.190**
- Device tree: `HelloVolla/android_device_volla_yggdrasilx`
- Device tree branch: `volla-10.1`
- Device BoardConfig selects `TARGET_KERNEL_CONFIG := gx290_defconfig`
- Board identity in the config: `k63v2_64_bsp`
- Screen: 720 × 1560
- Display drivers listed: `hx8394f_dsi_vdo_t20` and `hx8394f31_hdp_dsi_vdo`
- Touchscreen driver enabled: `CONFIG_TOUCHSCREEN_MTK_FOCALTECH_TS_V3=y`

The Volla device tree and kernel config are **board-specific**, not universal for every MT6763V phone.

## Cloud build (no local Linux installation)

1. Create a GitHub repository and upload the contents of this folder (including `.github/workflows/`).
2. In GitHub, open **Actions** and enable workflows if prompted.
3. Select **Build Volla Phone X reference kernel** → **Run workflow**.
4. When the run finishes, download the `yggdrasilx-reference-kernel` artifact. If the build fails, download `yggdrasilx-build-logs`.

The action runs on GitHub's Ubuntu runner; no VM, WSL, Ubuntu install, or local compiler is required on Windows.

## Important limitation

The target phone's reported SoC/display/storage assumptions are close to the Volla Phone X, but this does **not** prove it has the same motherboard, display panel, touch controller, PMIC, modem, bootloader, or partition layout. In particular, the Volla Phone X reference lists 4 GB RAM, while the supplied phone screenshots report 3 GB in one tab. The build artifacts must not be flashed to the target phone.

Before a device-specific image can be called flashable, the actual board and boot chain must be matched. See `FLASHING-GATE.md`.

## Build status honesty

The workflow and scripts are prepared for a remote run and can be statically checked locally. This environment cannot start a GitHub Actions job on an account that has not connected a repository, and it cannot execute a full Android kernel build here. Therefore, no successful kernel compile is claimed until the workflow itself completes and produces its artifact.
