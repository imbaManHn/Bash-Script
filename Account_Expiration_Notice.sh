#!/bin/bash
###########
# in this taks since there was no LDAP on our services and all the authority Management was based on ORA DB,
# i Had to check the account status on the DB Server, get the result and send an Email from Web server to the users.
# i Have added the SQL Code on another file Here (https://github.com/imbaManHn/Bash-Script/blob/master/DB-Part_for_Expired_accounts.sh)
# Note that i needed to Keep Log files as well for the result every day. i also needed these Log files to be in a simple format of Date
# Like YYYYMMDD so that is why i set the 'CurrentDate' Env virable.
### NOTE THAT YOU SHOULD CHANGE MANY NAMES and Paths IN THIS SCRIPT BASED ON YOUR NEEDs, THIS SCRIPT IS JUST TO SHOW YOU HOW TO DO ###
###########
# Setting the variables
CurrentDate=`date '+%Y%m%d'`
# my Home Directory on ALL Servers i need to use and on the Web server
# this script is running on the server that you need to use SMTP service to send mail, in my case it is the web server
DIR1="/home/MY-DIRECTORY/"
cd $DIR1
# SSH to run the DB Script on the DB Server from Web server
ssh oracle@DB1 <<'ENDSSH'sh /home/oracle/MY-DIRECTORY/MY-SCRIPT.sh  # Please Note the user is 'oracle' in our first SSH.
ENDSSH

# i Did not want to mess with any permissions of the users specially oracle user so i chose to just run the script via oracle.
# OPTIONAL: in this part since our cluster was being handled by a general user i needed to change the ownership of result files so i can work with it
# ssh root@DB1 <<'ENDSSH' chown GENERALUSER:users -R /home/oracle/MY-DIRECTORY/$CurrentDate   ENDSSH

echo =======copying results===============
rsync -rvahi "root@DB1:/home/MY-DIRECTORY/dates/*" /home/GENERALUSER/MY-DIRECTORY/dates/  # Copying the results from DB Server to Web server
echo =======cleaning the result file======
# i needed to get the reuslt file and clean them into single lines of Emails using at sign (@). 
# you see the issue was with sql plus when i used spool the result file also included the query itself.
# in below line i simply get the lines which have @ in them aka emails and send them to another file.
grep -hr "@"  /home/GENERALUSER/MY-DIRECTORY/dates/$CurrentDate/users.txt > /home/GENERALUSER/MY-DIRECTORY/$CurrentDate/result.txt

# Making the files sutiable and prepare for Emailing format. since i was going to use 'mailx' i decied to create each files i need based on the result.
# yeah you might say it makes it more challenging but it was more fun tho :))
# so i created 4 files: 'to.txt' , 'from.txt', and 'cc.txt'  and a 'msg.txt' file
# the file 'to.txt' includes just one line showing: to=""
# the file 'from.txt' only has a Line which shows: from="NAME-OF-SERVICE@YOUR-DOMAIN.com"
# the file 'cc.txt' is a one liner which shows: cc="THE EMAILS YOU WANT TO SEE IN CC SPERATED BY A COMMA"
# the 'msg.txt' File includes the message you want to email to the expiring users
cd /home/GENERALUSER/MY-DIRECTORY/dates/$CurrentDate/
# in here i use awk to paste the results from 'result.txt' in to the 'to.txt' file between two double qoutes.
awk '{print $1}' /home/GENERALUSER/MY-DIRECTORY/dates/$CurrentDate/result.txt | paste -s -d, - | sed 's/^/to="/;s/$/"/' > /home/GENERALUSER/MY-DIRECTORY/to.txt

# the Email part is pretty stragin forward based on above explaining
source /home/GENERALUSER/MY-DIRECTORY/to.txt
source /home/GENERALUSER/MY-DIRECTORY/from.txt
source /home/GENERALUSER/MY-DIRECTORY/cc.txt
echo $cc
echo $to
echo $from
# in below we used the Mailx to send the email based on the above files we also use 'msg.txt' and pipe it mailx
cat /home/GENERALUSER/MY-DIRECTORY/msg.txt | mailx -s "Account Expiration Notice" -r $from -c $cc -S smtp=10.10.10.100:25 -v $to
