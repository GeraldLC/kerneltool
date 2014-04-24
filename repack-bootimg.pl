#!/usr/bin/perl -W

use strict;
use Cwd;


my $dir = getcwd;

my $usage = "repack-bootimg.pl <kernel> <ramdisk-directory> <outfile>\n";

die $usage unless $ARGV[0] && $ARGV[1] && $ARGV[2];

chdir $ARGV[1] or die "$ARGV[1] $!";

system ("find . | cpio -o -H newc | gzip > $dir/ramdisk-repack.cpio.gz");

chdir $dir or die "$ARGV[1] $!";;

# Parameters for Toshiba Folio 100 only
system ("mkbootimg --cmdline 'mem=448M\x400M nvmem=64M\x40448M vmalloc=192M video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:122000:a00:800,linux:a0e00:1000:800,loader:300:400:800,mbr:700:200:800,system:900:20000:800,cache:20900:80000:800,misc:a0900:400:800,userdata:a1f00:80000:800 boardtype=PR' --kernel $ARGV[0] --ramdisk ramdisk-repack.cpio.gz -o $ARGV[2]");

unlink("ramdisk-repack.cpio.gz") or die $!;

print "\nrepacked boot image written at $ARGV[1]-repack.img\n";
