# Primary sources

## Existing Ubuntu Touch support

- UBports Volla Phone X device page (current release channels, support status and specifications): <https://devices.ubuntu-touch.io/device/yggdrasilx/>
- UBports Installer (Windows download and supported device workflow): <https://ubports.com/ubports-installer>
- UBports installer device config: <https://github.com/ubports/installer-configs/blob/master/v2/devices/yggdrasilx.yml>

## Volla Phone X Android device tree and kernel

- Device tree: <https://github.com/HelloVolla/android_device_volla_yggdrasilx/tree/volla-10.1>
- BoardConfig: <https://github.com/HelloVolla/android_device_volla_yggdrasilx/blob/volla-10.1/BoardConfig.mk>
- Device makefile: <https://github.com/HelloVolla/android_device_volla_yggdrasilx/blob/volla-10.1/device.mk>
- Kernel source: <https://github.com/HelloVolla/android_kernel_volla_yggdrasilx/tree/volla-10.1>
- Selected kernel config: <https://github.com/HelloVolla/android_kernel_volla_yggdrasilx/blob/volla-10.1/arch/arm64/configs/gx290_defconfig>
- MediaTek DT sources: <https://github.com/HelloVolla/android_kernel_volla_yggdrasilx/tree/volla-10.1/arch/arm64/boot/dts/mediatek>

The device BoardConfig selects `gx290_defconfig`; the kernel Makefile reports 4.9.190. The selected defconfig enables `CONFIG_MACH_MT6763`, labels the project `k63v2_64_bsp`, and includes 720×1560 LCD and FocalTech touchscreen configuration.

## Cross compiler used by the reference Android kernel build

- AOSP GCC 4.9 AArch64 toolchain: <https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+/refs/heads/android10-release>
- Pinned toolchain commit: `84fb09fafc92a3d9b4d160f049d46c3c784cc941`

All project references are read-only upstream sources. The build workflow does not patch or publish changes to those upstream repositories.
