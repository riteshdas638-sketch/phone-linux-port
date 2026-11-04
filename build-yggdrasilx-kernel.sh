#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/yggdrasilx-reference-build"
KERNEL="$WORK/android_kernel_volla_yggdrasilx"
TOOLCHAIN="$WORK/aarch64-linux-android-4.9"
OUT="$KERNEL/out"
ART="$ROOT/artifacts/yggdrasilx-reference"
mkdir -p "$WORK" "$ART"

KERNEL_COMMIT="dd40238e9fe086c38bad51b361bd9374b8254280"
TOOLCHAIN_COMMIT="84fb09fafc92a3d9b4d160f049d46c3c784cc941"
KERNEL_URL="https://github.com/HelloVolla/android_kernel_volla_yggdrasilx.git"
TOOLCHAIN_URL="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9"

log() { printf '\n[%s] %s\n' "$(date -u +'%FT%TZ')" "$*"; }

log "Clone pinned Volla Phone X kernel source"
git clone --depth=1 --branch volla-10.1 "$KERNEL_URL" "$KERNEL"
ACTUAL_KERNEL_COMMIT="$(git -C "$KERNEL" rev-parse HEAD)"
if [[ "$ACTUAL_KERNEL_COMMIT" != "$KERNEL_COMMIT" ]]; then
  echo "Kernel source branch moved: expected $KERNEL_COMMIT, got $ACTUAL_KERNEL_COMMIT" >&2
  exit 10
fi

log "Fetch the exact AOSP AArch64 GCC 4.9 toolchain revision"
# Use the manifest-pinned commit directly; branch names are not stable IDs.
git init "$TOOLCHAIN"
git -C "$TOOLCHAIN" remote add origin "$TOOLCHAIN_URL"
git -C "$TOOLCHAIN" fetch --depth=1 origin "$TOOLCHAIN_COMMIT"
git -C "$TOOLCHAIN" checkout --detach FETCH_HEAD
ACTUAL_TOOLCHAIN_COMMIT="$(git -C "$TOOLCHAIN" rev-parse HEAD)"
if [[ "$ACTUAL_TOOLCHAIN_COMMIT" != "$TOOLCHAIN_COMMIT" ]]; then
  echo "Toolchain commit mismatch: expected $TOOLCHAIN_COMMIT, got $ACTUAL_TOOLCHAIN_COMMIT" >&2
  exit 11
fi
CROSS="$TOOLCHAIN/bin/aarch64-linux-android-"
test -x "${CROSS}gcc"
export LD_LIBRARY_PATH="$TOOLCHAIN/lib:$TOOLCHAIN/lib64:${LD_LIBRARY_PATH:-}"
"${CROSS}gcc" --version | head -n 1 | tee "$ART/toolchain-version.txt"
grep -q "4\.9" "$ART/toolchain-version.txt" || { echo "Expected AOSP GCC 4.9 toolchain" >&2; exit 12; }

log "Verify source kernel version and selected defconfig"
grep -E '^(VERSION|PATCHLEVEL|SUBLEVEL) =' "$KERNEL/Makefile" | tee "$ART/kernel-version.txt"
test -f "$KERNEL/arch/arm64/configs/gx290_defconfig"

log "Configure the actual Volla Phone X reference kernel"
make -C "$KERNEL" O="$OUT" ARCH=arm64 CROSS_COMPILE="$CROSS" gx290_defconfig

CONFIG="$OUT/.config"
for expected in \
  'CONFIG_MACH_MT6763=y' \
  'CONFIG_MTK_PLATFORM="mt6763"' \
  'CONFIG_ARCH_MTK_PROJECT="k63v2_64_bsp"' \
  'CONFIG_LCM_HEIGHT="1560"' \
  'CONFIG_LCM_WIDTH="720"' \
  'CONFIG_TOUCHSCREEN_MTK_FOCALTECH_TS_V3=y'; do
  if ! grep -Fqx "$expected" "$CONFIG"; then
    echo "Expected reference setting missing from generated .config: $expected" >&2
    exit 20
  fi
done
cp "$CONFIG" "$ART/reference.config"

log "Compile kernel image and device trees"
make -C "$KERNEL" O="$OUT" ARCH=arm64 CROSS_COMPILE="$CROSS" \
  HOSTCC=gcc HOSTCXX=g++ -j2 Image.gz-dtb dtbs

IMAGE="$OUT/arch/arm64/boot/Image.gz-dtb"
if [[ ! -s "$IMAGE" ]]; then
  echo "Kernel build returned success but Image.gz-dtb is missing" >&2
  find "$OUT/arch/arm64/boot" -maxdepth 4 -type f -printf '%p\n' | sort | tee "$ART/boot-tree-files.txt"
  exit 21
fi

log "Collect built outputs"
mkdir -p "$ART/boot"
cp -f "$IMAGE" "$ART/boot/"
for candidate in \
  "$OUT/arch/arm64/boot/vmlinux" \
  "$OUT/arch/arm64/boot/dts/mediatek/mt6763.dtb" \
  "$OUT/arch/arm64/boot/dts/mediatek/k63v2_64_bsp.dtb" \
  "$OUT/arch/arm64/boot/dts/dtbo.img"; do
  if [[ -s "$candidate" ]]; then cp -f "$candidate" "$ART/boot/"; fi
done
find "$OUT/arch/arm64/boot" -type f \( -name '*.dtb' -o -name 'dtbo.img' \) -size +0c -print | sort > "$ART/device-tree-files.txt"
file "$ART/boot/Image.gz-dtb" | tee "$ART/image-file-type.txt"
sha256sum "$ART"/boot/* > "$ART/SHA256SUMS.txt"

cat > "$ART/BUILD-IDENTITY.txt" <<EOF
Reference only: Volla Phone X (yggdrasilx)
SoC family: MediaTek MT6763 / Helio P23
Kernel source: $KERNEL_URL
Kernel commit: $KERNEL_COMMIT
Kernel defconfig: gx290_defconfig
Toolchain source: $TOOLCHAIN_URL
Toolchain commit: $TOOLCHAIN_COMMIT
Board config: k63v2_64_bsp
Display config: 720x1560, HX8394F variants
Touchscreen config: FocalTech TS V3

NOT A FLASHABLE IMAGE FOR ANY OTHER PHONE.
Do not write these artifacts to the target clone.
EOF

log "Reference kernel build and output checks passed"
