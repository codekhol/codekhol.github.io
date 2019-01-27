:
#	This script will configure SCO TCP/IP version 1.1.3 for
#	upto 64 remote logins across the network. The earlier
#	version configured upto 32 for SCO TCP/IP 1.1.1. This 
#	script will work on SCO TCP/IP 1.1.1
#
#	basic script - pjw 11/09/90
#	increase to 48 - pjw 10/07/91
#	increase to 64 - pjw 16/12/91
#	prevent 3.2v4/TCP1.2 running - pjw 3/2/93
#
#idx tcplogin 1.5.0 TCP/IP Pseudo Terminal Enabler

# set up variables

TTY08="ttyp00 ttyp01 ttyp02 ttyp03 ttyp04 ttyp05 ttyp06 ttyp07"
TTY16="ttyp08 ttyp09 ttyp0a ttyp0b ttyp0c ttyp0d ttyp0e ttyp0f"
TTY24="ttyp10 ttyp11 ttyp12 ttyp13 ttyp14 ttyp15 ttyp16 ttyp17"
TTY32="ttyp18 ttyp19 ttyp1a ttyp1b ttyp1c ttyp1d ttyp1e ttyp1f"
TTY40="ttyp20 ttyp21 ttyp22 ttyp23 ttyp24 ttyp25 ttyp26 ttyp27"
TTY48="ttyp28 ttyp29 ttyp2a ttyp2b ttyp2c ttyp2d ttyp2e ttyp2f"
TTY56="ttyp30 ttyp31 ttyp32 ttyp33 ttyp34 ttyp35 ttyp36 ttyp37"
TTY64="ttyp38 ttyp39 ttyp3a ttyp3b ttyp3c ttyp3d ttyp3e ttyp3f"

VTY08="ptyp00 ptyp01 ptyp02 ptyp03 ptyp04 ptyp05 ptyp06 ptyp07"
VTY16="ptyp08 ptyp09 ptyp0a ptyp0b ptyp0c ptyp0d ptyp0e ptyp0f"
VTY24="ptyp10 ptyp11 ptyp12 ptyp13 ptyp14 ptyp15 ptyp16 ptyp17"
VTY32="ptyp18 ptyp19 ptyp1a ptyp1b ptyp1c ptyp1d ptyp1e ptyp1f"
VTY40="ptyp20 ptyp21 ptyp22 ptyp23 ptyp24 ptyp25 ptyp26 ptyp27"
VTY48="ptyp28 ptyp29 ptyp2a ptyp2b ptyp2c ptyp2d ptyp2e ptyp2f"
VTY56="ptyp30 ptyp31 ptyp32 ptyp33 ptyp34 ptyp35 ptyp36 ptyp37"
VTY64="ptyp38 ptyp39 ptyp3a ptyp3b ptyp3c ptyp3d ptyp3e ptyp3f"

tmpfile1=/tmp/ttyp$$
tmpfile2=/tmp/vty$$
tmpfile3=/tmp/ttys$$
tmpfile4=/tmp/mtune$$

savedir=/usr/tmp/kernel

hold() {
	echo "\npress [ENTER] to continue: \c"
	read junk
}

display() {
	clear ; cat << EOT

	Modifications to the kernel files have now been carried out
	to support $targetlogins users. Reboot the machine once the
	kernel itself and the kernel environment have been
	successfully rebuilt.

	The file /etc/auth/system/ttys has been updated with a 
	the new pseudo ttys. A copy of the original can be found
	in ${savedir}.

	Please now reboot your system to implement the changes made.

	Unix Support, Apricot
EOT
}

if [ -f /etc/perms/tcprt ]
then
	set -- `grep "#rel" /etc/perms/tcprt`
	case $1 in
		*rel=1.2*) echo "tcplogin: aborted"
			echo "This script is not required for SCO TCP/IP"
			echo "1.2.0 or later, you should use mkdev ptty" 
			exit 0
	esac
else
	echo "No perms file for TCP/IP found ...... aborting"
	exit 1
fi

targetlogins=$1
case $targetlogins in
	16|24|32|40|48|56|64) 
		;;
	*) 	echo "Usage: tcplogin 16|24|32|40|48|56|64"
	   	exit 0
		;;
esac

set -- `grep NTTYP /etc/conf/cf.d/stune`
currlogin=$2

if [ "$currlogin" != "" ]
then
	set -- `grep NTTYP /etc/conf/cf.d/mtune`
	default=$2 ; maxtty=$4
else
	set -- `grep NTTYP /etc/conf/cf.d/mtune`
	default=$2 ; maxtty=$4
	currlogin=$default
fi

echo "Current logins : $currlogin (default=${default})"
echo "Target logins  : $targetlogins"

if [ $currlogin -ge $targetlogins ]
then
	echo "Required logins already configured"
	exit 1
fi

case $targetlogins in
	16)	NEWTTY="$TTY08 $TTY16"  
		NEWVTY="$VTY08 $VTY16"
		;;
	24)	NEWTTY="$TTY08 $TTY16 $TTY24"
		NEWVTY="$VTY08 $VTY16 $VTY24"
		;;
	32)	NEWTTY="$TTY08 $TTY16 $TTY24 $TTY32"
		NEWVTY="$VTY08 $VTY16 $VTY24 $VTY32"
		;;
	40)	NEWTTY="$TTY08 $TTY16 $TTY24 $TTY32 $TTY40"
		NEWVTY="$VTY08 $VTY16 $VTY24 $VTY32 $VTY40"
		;;
	48)	NEWTTY="$TTY08 $TTY16 $TTY24 $TTY32 $TTY40 $TTY48"
		NEWVTY="$VTY08 $VTY16 $VTY24 $VTY32 $VTY40 $VTY48"
		;;
	56)	NEWTTY="$TTY08 $TTY16 $TTY24 $TTY32 $TTY40 $TTY48 $TTY56"
		NEWVTY="$VTY08 $VTY16 $VTY24 $VTY32 $VTY40 $VTY48 $VTY56"
		;;
	64)	NEWTTY="$TTY08 $TTY16 $TTY24 $TTY32 $TTY40 $TTY48 $TTY56 $TTY64"
		NEWVTY="$VTY08 $VTY16 $VTY24 $VTY32 $VTY40 $VTY48 $VTY56 $VTY64"
		;;
esac

if [ ! -d ${savedir} ]
then
	mkdir $savedir
fi

echo "Copying original node files to $savedir"
cp /etc/conf/node.d/ttyp /etc/conf/node.d/vty $savedir
echo "Copying mtune file to $savedir"
cp /etc/conf/cf.d/mtune $savedir
echo "Copying stune file to $savedir"
cp /etc/conf/cf.d/stune $savedir
echo "Copying ttys file to $savedir"
cp /etc/auth/system/ttys ${savedir}

cd /tmp

if [ ${targetlogins} -gt ${maxtty} ]
then
	cd /etc/conf/cf.d
	cat mtune | sed -e "s/NTTYP.*/NTTYP	8	0	${targetlogins}/" > $tmpfile4
	cp $tmpfile4 mtune
fi

echo "Building ttyp ............... \c"
count=0
cp /dev/null $tmpfile1
for ntty in $NEWTTY
do
	echo "ttyp	$ntty	c	$count" >> $tmpfile1
	count=`expr $count + 1`
done
echo "done"

echo "Building vty ................ \c"
count=0
cp /dev/null $tmpfile2
for nvty in $NEWVTY
do
	echo "vty	$nvty	c	$count" >> $tmpfile2
	count=`expr $count + 1`
done
echo "done"

echo "Building ttys ............... \c"
cp /dev/null ${tmpfile3}
cat /etc/auth/system/ttys | sed -e "/ttyp..:/d" > ${tmpfile3}
for ntty in $NEWTTY
do
	echo "${ntty}:t_devname=${ntty}:chkent:" >> $tmpfile3
done
echo "done"

cd /etc/conf/node.d
echo "Copying new node files to /etc/conf/node.d"
cp $tmpfile1 ttyp
cp $tmpfile2 vty
cd /etc/auth/system
echo "Copying new ttys file to /etc/auth/system"
cp $tmpfile3 ttys
cd /etc/conf/bin
echo "Tuning parameters"
echo "(if you are asked to OK a modification then respond 'y')"
./idtune NTTYP $targetlogins

echo "Relink kernel now [y]? \c"
read ans

case $ans in 
	N|n) 	display
	     	;;
	*) 	cd /etc/conf/cf.d
		./link_unix
		hold
		display
		;;
esac
	
rm -f $tmpfile1 $tmpfile2 $tmpfile3 $tmpfile4
