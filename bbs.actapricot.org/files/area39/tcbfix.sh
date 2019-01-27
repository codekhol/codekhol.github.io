:
# Script to correct file ownership, group and mode according to 
# the tcb database utility 'integrity'. This seems to fix the
# 'Useshell: File Control database inconsistancy' problem when
# creating users in sysadmsh.

getfield()
{
	Field=$1; shift
	Assign=$1; shift

	eval $Assign=\$$Field
}

CurFile=

/tcb/bin/integrity -e | while Line=`line`
do
	getfield 1 Fname $Line

	if [ -f $Fname -o -d $Fname -o -c $Fname -o -b $Fname ]; then
		CurFile=$Fname
	else
		getfield 6 Param $Line
		Param=`expr "$Param" : '\(.*\)\.'`

		case $Fname in
		Owner)	
			command=chown
			;;
		Group)
			command=chgrp
			;;
		Mode)
			command=chmod
			;;
		Type)
			command=echo
			;;
		*)
			echo "Unknown field $Fname"
			continue
			;;
		esac

		Setit="$command $Param $CurFile"

		echo "Issuing $Setit ...\c"
		$Setit

		echo
	fi
done
