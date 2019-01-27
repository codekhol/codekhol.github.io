:
SHELL=/bin/sh	export SHELL
tmpfile1=/tmp/dos1$$
tmpfile2=/tmp/dos2$$


dollar() {
    newfile=`echo ${file} |\
    awk '{
        newfile = $0;
	do {
	    tmpfile = newfile;
	    pos = index(tmpfile, "\$");
            if(pos > 0) {
                pre = substr(tmpfile, 0, pos-1);
		post = substr(tmpfile, pos+1);
		newfile = sprintf("%s_%s", pre, post);
	    } else {
	        newfile = sprintf("%s", tmpfile);
	    }
	} while(pos > 0);
	printf("%s", newfile);
    }'`
}
echo "This script will read in the file in the root directory of"
echo "the MS-DOS disk to the current directory under Xenix/Unix"
echo
echo "Please insert disk to process and press [ENTER] when ready: \c"
read junk

dosls a: > $tmpfile1
num=0
echo "DOS FILES TRANSFERRED TO XENIX" >> LOGFILE
echo "******************************" >> LOGFILE

for file in `cat $tmpfile1`
# for file in C*
do
	num=`expr $num + 1`
	dollar
	doscp a:$file $newfile
	echo "File Transfer	 DOS: $file 	XENIX: $newfile"
	echo "File Transfer	 DOS: $file 	XENIX: $newfile" >> LOGFILE
done
echo "A list of the files copied from the DOS disk to Xenix is contained"
echo "in the file LOGFILE"
rm -f $tmpfile1 
