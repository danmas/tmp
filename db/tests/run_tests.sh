#!/bin/bash
set -e

echo "current dir: $0"
basedir=`dirname $0` 
current_path=`cd $basedir; pwd` 

echo 'using path: ' $current_path 
echo "basedir: $basedir"
cd  $current_path

if [ ! -f ../install/config.cfg ] ; then
 echo 'Error! File ../install/config.cfg does not exist. Please create it:
	$ cp .../tmp/config.cfg.example config.cfg
	$ vi config.cfg'

 exit 1
fi;

# Load settings:
. ../install/config.cfg

echo 'Yours config in db/install/config.cfg is:

	db_host     : '$db_host'
	db_port     : '$db_port'
	db_user     : '$db_user'
	db_name     : '$db_name'
	log_path    : '$log_path'
'
ans='Y'
read -p "Run the check of scenario? [y]/n:"  ans
if [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
	exit 1
fi;

#-- удаляем лог
if [ -f $log_path/tests.log ] ; then
	rm $log_path/tests.log
fi;	

#echo "Create tests... . See logs in $log_path/tests.log"
psql -v db_user=$db_user -h $db_host -p $db_port -d $db_name -U $db_user -v db_pass="'$db_pass'" -v db_name=$db_name \
-f ./sql/create_tests.sql #&>>$log_path/tests.log

echo "Checking db structure... . See logs in $log_path/tests.log"
psql -v db_user="'$db_user'" -h $db_host -p $db_port -d $db_name -U $db_user -v db_pass="'$db_pass'" -v db_name=$db_name \
-f ./sql/check_db_struct.sql #&>>$log_path/tests.log

echo "Checking the scenario results... . See logs in $log_path/tests.log"
psql -v db_user="'$db_user'" -h $db_host -p $db_port -d $db_name -U $db_user -v db_pass="'$db_pass'" -v db_name=$db_name \
-f ./sql/check_scenario.sql #&>>$log_path/tests.log

echo "Checking carl_auth schema... . See logs in $log_path/tests.log"
psql -v db_user="'$db_user'" -h $db_host -p $db_port -d $db_name -U $db_user -v db_pass="'$db_pass'" -v db_name=$db_name \
-f ./sql/check_auth.sql #&>>$log_path/tests.log


 
echo "See logs in $log_path/tests.log"
#tail -20 $log_path/tests.log

