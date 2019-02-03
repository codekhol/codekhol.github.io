:
#	script for checking the ttys files under Unix and 
#	attempting to correct them.
#	19-02-91	PJW
#
#idx checkttys 1.2 Checker for UNIX ttys file

sysname=amber
safefile=/etc/auth/system/ttys.good
users="peterw"

inform() {
	mess=$1 stat=$2
	mail -s "${sysname}: ${stat}" ${users} << EOT

	MESSAGE: ${mess}

EOT
}

cd /etc/auth/system
if [ -f ttys ]
then
	set -- `ls -l ttys`
	sizettys=$5
	if [ ${sizettys} -gt 500 ]
	then
		# no message required - all OK
		rm -f ttys-t ttys-o
	fi
	exit 0
fi

if [ -f ttys-t ]
then
	set -- `ls -l ttys-t`
	sizettys=$5
	if [ ${sizettys} -gt 500 ]
	then
		inform "Used ttys-t, size ${sizettys}" "[ttys - fixed]"
		mv ttys-t ttys
		rm -f ttys-o
	fi
	exit 0
fi

if [ -f ttys-o ]
then
	set -- `ls -l ttys-o`
	sizettys=$5
	if [ ${sizettys} -gt 500 ]
	then
		inform "Used ttys-o, size ${sizettys}" "[ttys - fixed]"
		mv ttys-o ttys
	fi
	exit 0
fi

cp ${safefile} ttys
inform "ttys error - used ${safefile}" "ttys - temporary repair"
