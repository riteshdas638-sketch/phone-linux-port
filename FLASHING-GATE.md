# Flashing gate — do not bypass

No image in this project is approved for flashing to the target phone.

The Volla Phone X reference is the best lead found so far, but the supplied screenshots are software-reported values and do not prove the clone has the same `yggdrasilx` / `k63v2_64_bsp` board.

A target image may be called flashable only after all of the following are matched:

1. Actual board identifier / device-tree compatible string, not a product-name string from Android settings.
2. Bootloader family, boot image format, AVB state and recovery/fastboot behaviour.
3. Partition names, sizes, offsets and A/B or single-slot layout.
4. Display panel driver and timing; touchscreen controller and firmware.
5. PMIC, charging, storage/eMMC, modem and required firmware blobs.
6. A tested recovery / restoration path for the original firmware.

The official Volla Phone X installer bootstrap includes low-level device-specific partitions. It is not a safe generic MT6763 flashing utility.

The cloud kernel artifact is for source inspection and development only. Do not write its `Image.gz-dtb`, DTB, DTBO, boot image or any partition image to the clone.
