#!/bin/sh

function init_file
{
	if [ -z "$1" ] 
	then
		file_name="config.php"
	else
		file_name="$1"
	fi
	
	echo "<?php" > "$file_name"
	tf
	tf
	tf "## sds installation variables"
	tf "## this file was autogenerated, please do not edit by hand"
	tf "## use the script"
}

function tf
{
	if [ -z "$1" ]
	then
		echo "" >> "$file_name"
	else
		echo "$1" >> "$file_name"
	fi
}

case `id` in
"uid=0("*)
username=sds
tuser=sds
database=sdb
baselocation=/var/www/html/sds
  ;;
*)
  ids=`id`
  username=`echo $ids | awk '{print $1}' | grep -E -o "\(.*\)" | grep -E -o "[^()]+"`
  echo "Hello $username"
  baselocation="/home/$username/sds"
  # KAB CHANGE (removed ~ form tuser since auto-homing and ssl aren't playing nicely) 
  # tuser="~$username"
  tuser="sandbox/$username"
  database="sdb_$username"
  ;;
esac

if [ "$1" = "root" ]; then
username=sds
tuser=sds
database=sdb
baselocation=/var/www/html/sds
fi


init_file

tf "define ('SDS_HOME_URL', \"https://simmons.mit.edu/$tuser/home.php\");"
tf "define ('SDS_LOGIN_URL', \"https://simmons.mit.edu/$tuser/login/certs/login.php\");"
tf "define ('SDS_AUTO_LOGIN_URL', \"https://simmons.mit.edu/$tuser/login/certs/login.php?auto=1\");"
tf "define ('SDS_BASE', \"$baselocation\");"
tf "define ('SDS_BASE_URL', \"https://simmons.mit.edu/$tuser/\");"
tf "define ('SDS_COOKIE_PATH', \"/$tuser\");"
tf "define ('SDB_DATABASE', \"$database\");"
tf "define ('SDB_PASSWORD_FILE', \"/var/www/sds/sdb-passwd-apache-without-dbname\");"
tf "define ('SDS_QUERY_LOG', \"/var/www/sds/log/querylogs/$username\");"
tf
tf
tf '?>'

