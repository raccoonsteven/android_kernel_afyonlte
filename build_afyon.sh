#!/bin/bash 

# Build Variables
export version=ZERO_KERNEL-0.5d-linaro
export TOOLCHAIN=/home/dm47021/Android/toolchains/linaro-4.9.4-cortex-a7/bin/arm-cortex_a7-linux-gnueabihf-

export CPU_CORES=4

# Colorize and add text parameters
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
cya=$(tput setaf 6) # cyan
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
bldcya=${txtbld}$(tput setaf 6) # cyan
txtrst=$(tput sgr0) # Reset

echo""
echo -e "${bldred} 
     Cleaning Build Directory 
${txtrst}"

rm -rf ./$version-DM47021.zip
rm -rf zfiles/packaging/system/lib/modules/pronto/pronto_wlan.ko

make mrproper

loc=~/.gnome2/nautilus-scripts/SignScripts/
date=$(date +%Y%m%d-%H:%M:%S)

# Check for a log directory in ~/ and create if its not there
[ -d ~/logs ] || mkdir -p ~/logs

echo""
echo -e "${bldgrn} 
      Source is Sanitary 
${txtrst}"


echo""
echo -e "${bldblu} 
      Building ZERO Kernel By DM47021 From Source
${txtrst}" 


echo""
echo -e "${bldblu} 
      Removing Old .config files
${txtrst}" 
rm -rf .config

echo""
echo -e "${bldblu} 
      Setting up Zero_Configuration
${txtrst}" 
cp zero_afyonlte_defconfig .config

make -j$CPU_CORES ARCH=arm CROSS_COMPILE=$TOOLCHAIN

echo -e "${bldgrn} 
      Kernel Built Sucessfully!!
${txtrst}" 

echo -e "${bldgrn} 
      Kernel Modules can be found in zfiles/packaging/system/lib/modules
${txtrst}"

# Create dir struct
mkdir zfiles/packaging/system/lib/modules
mkdir zfiles/packaging/system/lib/modules/pronto

find -name '*.ko' -exec cp -av {} zfiles/packaging/system/lib/modules/ \;
cp zfiles/packaging/system/lib/modules/pronto_wlan.ko zfiles/packaging/system/lib/modules/pronto/pronto_wlan.ko
rm -rf zfiles/packaging/system/lib/modules/pronto_wlan.ko

# Build dt.img
echo""
echo -e "${bldcya} 
      Building new dt.img
      The end result will be dt.img  in arch/arm/boot 
${txtrst}" 

./bin/dtbTool -o arch/arm/boot/dt.img -s 2048 -p ./scripts/dtc/ ./arch/arm/boot/

# Copy Prequisites for making Boot.img
cp arch/arm/boot/dt.img zfiles/
cp arch/arm/boot/zImage zfiles/


echo""
echo -e "${bldcya} 
      Building Boot.img
${txtrst}" 

cd zfiles
./mkbootzip.pl ramdisk/cm12.1

echo""
echo -e "${bldcya} 
      Boot.img built
      Building Zipfile
${txtrst}" 

cd ../

cp zfiles/zero-krnl.zip ./$version-DM47021.zip

echo""
echo -e "${bldcya} 
    Flashable zip created 
    zero-krnl.zip in the root of the build dir
${txtrst}" 

echo""
echo -e "${bldred} 
     Cleaning Up Working Dirs
${txtrst}"

# Remove dirs after build
rm -rf zfiles/packaging/boot.img 
rm -rf zfiles/zImage 
rm -rf zfiles/zero-krnl.zip
rm -rf zfiles/packaging/system/lib/modules

# Wait for user input
echo""
read -p "Press [Enter] to exit this script..."
