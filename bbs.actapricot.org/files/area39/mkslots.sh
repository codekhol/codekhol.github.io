	:
	params="makeslots: nslots [directory]"
	if [ $# -eq "2" ]
	then
	  dir=$2
	elif [ $# -eq "1" ]
	then
	  dir=`pwd`
	else
	  echo $params
	  exit 1
	fi
	if [ ! -d $dir ]
	then
	  echo $params
	  exit 1
	fi
	cd $dir

        echo "makeslots: create empty slots in $dir"
        maxcount=$1
        count=0
        while [ $count -lt $maxcount ]
        do
          cp /dev/null $count
          count=`expr $count + 1`
	  echo "Slot # $count\r\c"
        done
        count=0
	echo "\nRemoving dummy files"
        while [ $count -lt $maxcount ]
        do
          rm $count
          count=`expr $count + 1`
        done
        echo "Directory `pwd` now has $count empty slots"

