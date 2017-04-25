#!/bin/bash
set -e

echo "current dir: $0"
basedir=`dirname $0` 
current_path=`cd $basedir; pwd` 

echo 'using path: ' $current_path 
echo "basedir: $basedir"
cd  $current_path

if [ ! -f ./config.cfg ] ; then
 echo 'Error! File config.cfg does not exist. Please create it:
	$ cp ./tmp/config.cfg.example config.cfg
	$ vi config.cfg'

 exit 1
fi;

# Load settings:
. config.cfg

echo 'Yours config is:

	db_host     : '$db_host'
	db_port     : '$db_port'
	db_user     : '$db_user'
	db_name     : '$db_name'
	log_path    : '$log_path'
'
ans='Y'
read -p "Continue installation? [y]/n:"  ans
if [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
	exit 1
fi;

#rm $log_path/install.log

#echo "Creating schema $work_schema. Enter your schema user password."
psql -h $db_host -p $db_port -d $db_name -U $db_user \
	-f ./sql/api_procedures.sql #&>> $log_path/install.log

#echo "See logs in $log_path/install.log"
#tail -20 $log_path/install.log
