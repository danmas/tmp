#!/bin/bash
set -e

if [ ! -f config.cfg ] ; then
 echo 'Error! File config.cfg does not exist. Please create it:
       $ cp ./tmp/config.cfg.example install.cfg
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
	work_schema : '$work_schema'
	log_path    : '$log_path'
'
ans='no'
read -p "Continue deinstallation(drop database $db_name, drop role $db_user)? yess/[no]:"  ans
if [ "$ans" = "yess" ] ; then

	read -p "Are you crazy? [yes]/no:"  ans
	if [ "$ans" = "no" ] ; then
		echo "Dropping database $db_name."
		psql -v db_user=$db_user -v db_pass="'$db_pass'" -v db_name=$db_name -h $db_host -p $db_port -U postgres -f ./sql/drop_db.sql
	fi;
fi;
