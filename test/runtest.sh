#!/bin/sh

# UNIX only
# trivial script used to generate test CSV file for our reader 
gen_test()
{
	rows=$1
	filename=$2

	if [ -e $filename ]
	then
		# do not generate again
		echo [SUCCESS] \"$filename\" test CSV file was already generated.
		return
	fi

	# generate N row CSV test file
	echo [INFO] Try to generate CSV file with $rows rows.
	for (( i=1; i<=$rows; i++ ))
	do
		echo $RANDOM,\"$RANDOM\",$RANDOM.$RANDOM,$RANDOM,\"\"\"$RANDOM\"\"\" >> $filename 
	done
	echo [SUCCESS] $filename generated.
}

echo "+------------------------+"
echo "|    RUNNING TESTS       |"
echo "+------------------------+"

# generate testfile with 5 000 000 lines
let rows=5*1000000
testdir=`dirname "$0"`
testcsv=$testdir/test.csv
gen_test $rows $testcsv 

# check if csv_test binary exists
if [ ! -e "test" ]; then
	echo [ERROR] csv_test binary not found
	echo [ERROR] Please execute \"make\" inside of \"`readlink -f ../`\"
fi

# run simple test
let cols=5*$rows

# testrounds
rounds=5
for (( i=1; i<=$rounds; i++ ))
do
	echo [INFO] test round $i ... 
	$testdir/test "$testcsv" $rows $cols
	if [ ! $? -eq 0 ]; then
		echo [ERROR] Test failed!
		exit -1
	fi
done

