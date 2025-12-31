# Rockchip RK3566 quad core 1/2/4/8GB RAM WiFi/BT or GBE HDMI USB-C
BOARD_NAME="BrutzelBoy V2"
BOARD_VENDOR="radxa"
BOARDFAMILY="rk35xx"
BOARD_MAINTAINER=""
BOOTCONFIG="lckfb-tspi-rk3566_defconfig"
KERNEL_TARGET="vendor,current,edge"
KERNEL_TEST_TARGET="vendor,current"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3566-lckfb-tspi.dts.dtb"
IMAGE_PARTITION_TABLE="gpt"
BOOT_SCENARIO="spl-blobs"

PACKAGE_LIST_BOARD="rfkill bluetooth bluez bluez-tools"
# add for OBEX file transfer:
# PACKAGE_LIST_BOARD+=" bluez-obexd"
#AIC8800_TYPE="sdio"
#enable_extension "radxa-aic8800"

function post_family_config__use_mainline_uboot() {

	# boot.scr will use whatever u-boot detects and sets 'fdtfile' to.
	# This however this doesn't work with Rockchip bsp based kernels since naming differs.
	# So leave decision to u-boot ONLY when mainline kernel is used.
	if [[ "${BRANCH}" != "vendor" ]]; then
		unset BOOT_FDT_FILE
	fi

	BOOTCONFIG="lckfb-tspi-rk3566_defconfig"
	BOOTSOURCE="https://github.com/u-boot/u-boot"
	BOOTBRANCH="tag:v2025.10"
	BOOTPATCHDIR="v2025.10"

	UBOOT_TARGET_MAP="BL31=$RKBIN_DIR/$BL31_BLOB ROCKCHIP_TPL=$RKBIN_DIR/$DDR_BLOB;;u-boot-rockchip.bin"
	## For binman-atf-mainline: setting BOOT_SCENARIO at the top would break branch=vendor, so we don't enable it globally.
	# We cannot set BOOT_SOC=rk3566 due to side effects in Armbian scripts; ATF_TARGET_MAP is the safer override.
	# ATF does not currently separate rk3566 from rk3568.
	#ATF_TARGET_MAP="M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=rk3568 bl31;;build/rk3568/release/bl31/bl31.elf:bl31.elf"
	#UBOOT_TARGET_MAP="BL31=bl31.elf ROCKCHIP_TPL=$RKBIN_DIR/$DDR_BLOB;;u-boot-rockchip.bin"

	unset uboot_custom_postprocess write_uboot_platform write_uboot_platform_mtd

	function write_uboot_platform() {
		dd if=$1/u-boot-rockchip.bin of=$2 seek=64 conv=notrunc status=none
	}
}

