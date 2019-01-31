#!/bin/bash

#in this scrip we will add user($username) and pass($password) to Linux,then we move to Nginx and make a Virtualhost for it(just for HTML index)
#then we move to mysql and create the same username with a database for it with the name of user_db.
#then we can check in our terminal by logging in to our user and logging in to mysql with the same password and
#accessing to our Database
#Here we go :

# Script to add a user to Linux system
#we will just add a user and a pass but remember we made this user pass to work all along the way
#meaning this user will be same as the Virtual host in nginx for it then used for mysql database too
#so remember what username and password u make

if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
    
#if you are wondering what is the "perl" line doing here i have to say its just helps to check security of the password   

		useradd -m -p $pass $username
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi

#now we get to the part of Nginx
#the part to creat virtual host for NGINX

domain=$username

root="/var/www/$domain/html"
block="/etc/nginx/sites-available/$domain"

# Create the Document Root directory
sudo mkdir -p $root

# Assign ownership to your regular user account since it must be the root or the creator of the Virtualhost just
#to be able to access it

sudo chown -R $USER:$USER $root

# Create the Nginx server block file:

sudo tee $block > /dev/null <<EOF 
server {
        listen 80;
        listen [::]:80;

        root /var/www/$domain/html;
        index index.html index.htm;

        server_name $domain www.$domain;

        location / {
                try_files $uri $uri/ =404;
        }
}


EOF

# Link to make it available
sudo ln -s $block /etc/nginx/sites-enabled/

# Test configuration and reload if successful
sudo nginx -t && sudo service nginx reload


#The part to make database in mysql with the user name and password we made up there

# take the $pass in the pass making part

PASSWDDB=$password

#take the same username as $username
MAINDB=$username

# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${MAINDB}_db /*\!40100 DEFAULT CHARACTER SET utf8 */;CREATE USER ${MAINDB}_user@localhost IDENTIFIED BY '${PASSWDDB}';GRANT ALL PRIVILEGES ON ${MAINDB}_db.* TO '${MAINDB}_user'@'localhost';FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    #echo "Please enter root user MySQL password:"
    read -s -p "Enter your mysql user password:" rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${MAINDB}_db /*\!40100 DEFAULT CHARACTER SET utf8 */;CREATE USER ${MAINDB}_user@localhost IDENTIFIED BY '${PASSWDDB}';GRANT ALL PRIVILEGES ON ${MAINDB}_db.* TO '${MAINDB}_user'@'localhost';FLUSH PRIVILEGES;"

fi
