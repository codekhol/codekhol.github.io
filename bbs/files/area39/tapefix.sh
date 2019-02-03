:
echo "WARNING: This script will modify your kernel"
echo "The modified kernel will be installed as /xenix"
echo "The previous kernel will be renamed as /xenix.prior"
echo
cd /
cp xenix xenix.patch
adb -w xenix.patch << ADB_EOF
scstopen+0x213?w 0x8b02
scstopen+0x21a?w 0x8b02
scstopen+0x221?w 0x8b08
scstopen+0x228?w 0x8b02
scstopen+0x22f?w 0x8b00
scstopen+0x1ec,12?i
$q
ADB_EOF
mv xenix xenix.prior
ln xenix.patch xenix
echo
echo "You must now reboot your system - "
echo "If the new kernel will not boot, reboot off /xenix.prior"
