#!/bin/bash 

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

make -j64 ARCH=arm CROSS_COMPILE=/home/dm47021/Android/toolchains/arm-eabi-4.7/bin/arm-eabi- msm8226-sec_defconfig VARIANT_DEFCONFIG=msm8926-sec_afyonltetmo_defconfig
make -j64 ARCH=arm CROSS_COMPILE=/home/dm47021/Android/toolchains/arm-eabi-4.7/bin/arm-eabi-

echo -e "${bldgrn} 
      Kernel Built Sucessfully!!
${txtrst}" 

find -name '*.ko' -exec cp -av {} zfiles/packaging/system/lib/modules/ \;

# Build dt.img
echo""
echo -e "${bldcya} 
      Building new dt.img
      The end result will be dt.img  in arch/arm/boot 
${txtrst}" 

./dtbTool -o arch/arm/boot/dt.img -s 2048 -p ./scripts/dtc/ ./arch/arm/boot/

# Copy Prequisites for making Boot.img
cp arch/arm/boot/dt.img zfiles/
cp arch/arm/boot/zImage zfiles/


echo""
echo -e "${bldcya} 
      DONT FORGET TO RUN ./mkbootzip.pl ramdisk_stk
      This will result in a twrp flashable kernel zip
${txtrst}" 

# Wait for user input
echo""
read -p "Press [Enter] to exit this script..."
