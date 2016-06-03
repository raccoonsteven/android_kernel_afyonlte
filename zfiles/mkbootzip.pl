#!/usr/bin/perl -W

use strict;
use Cwd;


my $dir = getcwd;

my $usage = "zcwmkrnl.pl <ramdisk-directory>\n";

die $usage unless $ARGV[0];

chdir $ARGV[0] or die "$ARGV[0] $!";

system ("find . | cpio -o -H newc | gzip > $dir/ramdisk-repack.gz");

chdir $dir or die "$ARGV[0] $!";;

# Parameters for Samsung Galaxy Avant
system ("$dir/mkbootimg --cmdline 'console=null androidboot.console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37' --kernel zImage --ramdisk ramdisk-repack.gz -o boot.img --dt dt.img --base 0x0000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x1e00000");
print "\nrepacked boot image written at boot.img\n";
unlink("ramdisk-repack.gz") or die $!;
system ("rm $dir/zero-krnl.zip");
print "\nremoved old zero-krnl.zip\n";
system ("rm $dir/packaging/boot.img");
print "\nremoved old boot.img from $dir/packaging/\n";
system ("cp boot.img $dir/packaging/");
print "\ncopied new boot.img to $dir/packaging\n";
system ("rm boot.img");
print "\nremoved temporary boot.img\n";
chdir ("$dir/packaging");
system ("zip -9 -r $dir/zero-krnl.zip *");
print "\nceated zero-krnl.zip\n";
print "\ndone\n";



