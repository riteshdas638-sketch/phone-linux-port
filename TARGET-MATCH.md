# Target match assessment

## Close match to Volla Phone X (`yggdrasilx`)

| Property | Working target assumption | Official Volla Phone X reference |
|---|---|---|
| SoC | MediaTek MT6763V / Helio P23 | MT6763V / Helio P23 |
| CPU | 8× Cortex-A53 (4× 2.0 GHz + 4× 1.5 GHz) | Same |
| GPU | Mali-G71 MP2 | Same |
| Display | 720 × 1560 | 720 × 1560, 6.1-inch IPS |
| Storage | 64 GB | 64 GB eMMC |
| RAM | 3 GB reported in one tab | 4 GB DDR3 |

The combination is a strong reference lead, not proof of identical hardware.

## Board-level configuration we can use as a reference

The `HelloVolla/android_device_volla_yggdrasilx` `volla-10.1` BoardConfig selects `gx290_defconfig`, and its device makefile sets the screen to 720 × 1560. The matching kernel defconfig enables MT6763, identifies the project as `k63v2_64_bsp`, lists two candidate HX8394F 720×1560 LCD drivers, and enables the FocalTech TS V3 touchscreen driver.

These are the most valuable details to compare with the clone's real board. The panel or touchscreen may be different even when the SoC and resolution are the same.

## Kernel type

The Volla Phone X source is a downstream MediaTek Android kernel, version 4.9.190. Ubuntu Touch for this device uses Halium 10.0. This is not the postmarketOS mainline MT6763 port from the older, non-X Volla Phone; do not mix their images or device trees.
