# this is the DB Part of account Expiration Notice Automation, which this script should be placed on your DB Server with the ownership and permission for
# Oracle DB user. in our Case our Oracle was installed on SUSE 12. so i had to run this script via sql plus.

#!/bin/bash
CurrentDate=`date '+%Y%m%d'`
DIR1="/home/oracle/MY-DIRECOTORY/dates"
source /home/oracle/.profile #Loading the Profile of the Oracle user if it exists, to get all its Env variables which we have set before
cd $DIR1
find . -type d -ctime +5 | xargs rm -rf  # Cleaning the older files every day when this script runs

mkdir $CurrentDate  # Making the current directory based on Date
cd $CurrentDate

sqlplus / as sysdba <<EOF
set serveroutput off;
set heading off;
set feedback off;
set echo off;
set wrap off;
spool /home/oracle/MY-DRIECTORY/dates/$CurrentDate/users.txt  ## getting the results in a text file (note that the extention of file does not matter)
select
t.e_mail  # we need the user's Emails only to send them the notice
from authority.userinfo t  # or what ever the Table Name is in your DB
where t.deleteflag = 0  # if you have the flagging system in your DB Like we did
and t.locked = 0
and t.expired = 0
and to_char(t.staffenddate, 'yyyyMMdd')=to_char(sysdate +7,'yyyyMMdd'); # you should Note the period of time. this means based on 'staffenddate' attribute ...
# we consider today's date and query which users will be exired 7 days from now. so the result will be Emails of those users which expire in 7 days.
spool off;
exit
EOF
echo ===================D O N E ==================
