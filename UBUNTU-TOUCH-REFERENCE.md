# Existing mobile Linux OS: Ubuntu Touch for Volla Phone X

As of 4 November 2026, the official UBports device page lists:

- Device: Volla Phone X
- Codename: `yggdrasilx`
- Port base: Halium 10.0
- Stable channel: Ubuntu 20.04 Focal OTA-12 (release date shown as 2 June 2026)
- Development channel: 20.04 build dated 27 July 2026
- Support rating: Advanced support; essential phone features are reported working

Official page: <https://devices.ubuntu-touch.io/device/yggdrasilx/>

The official page says installation is done with the UBports Installer on Windows, macOS or Linux. It requires a supported device and bootloader unlock. Ubuntu Touch is a real native phone OS, not an Android launcher.

**Do not select Volla Phone X in the installer for a generic clone merely because the CPU and screen resolution look similar.** The installer has device-specific boot images and low-level firmware steps. A mismatch in board, bootloader, display/touch hardware or partition layout can make the phone unbootable.
