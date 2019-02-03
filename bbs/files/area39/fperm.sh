:
#idx fperm 1.0.0 Full Permission checker.

cd /

tmpfile=/tmp/fperm$$
pfiles=`find /etc/perms -type f -print | sed -e "/bundle/d"`
numpfiles=`find /etc/perms -type f -print | sed -e "/bundle/d" | wc -l`

echo "Do you wish to change permissions if errors"
echo "are detected [N]? \c"
read cpans
case ${cpans} in
	Y|y) 	flags="-c"
		;;
	*)	flags="-n"
		;;
esac

clear
echo "Commencing full permissions check (using all perms files in /etc/perms)"
echo "======================================================================="
echo
for pfile in ${pfiles}
do
	echo "Processing: ${pfile}      \r\c"
	echo "\n**** Starting check: ${pfile}" >> ${tmpfile}
	echo " " >> ${tmpfile}
	/etc/fixperm ${flags} ${pfile} 2>> ${tmpfile}
	echo "\n**** Completed check: ${pfile}" >> ${tmpfile}
done
echo "Processing: completed                 "

if [ -f ${tmpfile} ]
then
	inu=`grep "incorrect uid" ${tmpfile} | wc -l`
	inm=`grep "incorrect mode" ${tmpfile} | wc -l`
	nef=`grep "not an empty file" ${tmpfile} | wc -l`
	fnf=`grep "file not found" ${tmpfile} | wc -l`
	cat << EOT


File Permissions Statistics
===========================

Number of Perms files: ${numpfiles}
Warnings
	Incorrect uid/gid :	${inu}
	Incorrect mode    :	${inm}
	Not an empty file :	${nef}
	File not found    :	${fnf}


EOT
	echo "Do you wish to examine the output [N]: \c"
	read ans
	case ${ans} in 
		Y|y)	# examine results file
			more ${tmpfile}
			;;
	esac
fi

rm -f ${tmpfile}
