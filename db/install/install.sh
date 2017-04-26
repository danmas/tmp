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

read -p "Database $db_name and user $db_user will be droped. Continue? [y]/n:"  ans
if [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
	exit 1
fi;

read -p "Please input database schema owner ($db_user) password:" db_pass

if [ -f $log_path/install.log ] ; then
	rm $log_path/install.log
fi;	
echo "Creating database $db_name with user $db_user. See logs in $log_path/install.log"
psql -v db_user=$db_user -v db_pass="'$db_pass'" -v db_name=$db_name -h $db_host -p $db_port -U postgres \
  -f ./sql/create_db.sql &>>$log_path/install.log

#echo "Enabling extensions in database. Enter your postgres user password."
#psql -h $db_host -p $db_port -d $db_name -U postgres -f ./sql/extensions.sql &>$log_path/install.log

echo "Creating all schemas. Enter your db user password."
psql -h $db_host -p $db_port -d $db_name -U $db_user \
  -f ./sql/install.sql &>> $log_path/install.log

echo "Playing scenario ../tests/sql/play_scenario.sql"
psql -h $db_host -p $db_port -d $db_name -U $db_user \
  -f ../tests/sql/play_scenario.sql &>> $log_path/install.log

echo "See logs in $log_path/install.log"
tail -20 $log_path/install.log

echo "Please execute integration tests. ../tests/run_tests.sh"

