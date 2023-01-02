# this is the DB Part of account Expiration Notice Automation, which this script should be placed on your DB Server with the ownership and permission for
# Oracle DB user. in our Case our Oracle was installed on SUSE 12. so i had to run this script via sql plus.
#!/bin/sh/
sqlplus / as sysdba <<EOF
set serveroutput off;
set heading off;
set feedback off;
set echo off;
set wrap off;
spool /home/oracle/MY-DIRECTORY/expd-users.txt
select
t.e_mail
from authority.userinfo t # or what ever the Table Name is in your DB
where t.deleteflag = 0 # if you have the flagging system in your DB Like we did
and t.locked = 0
and t.expired = 0
and to_char(t.staffenddate, 'yyyyMMdd')=to_char(sysdate +3,'yyyyMMdd');
spool off;
exit
EOF
exit;
