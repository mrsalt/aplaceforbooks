# Purpose

This repository will contain the code to support a website that will include a petition focused in a local area.

# Server Install
See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html.

## Step 1: Prepare the LAMP server

1. Connect to your instance.  `ssh ec2-user@<public IP>`
2. Update packages.  `sudo yum update -y`
3. Install the lamp-mariadb10.2-php7.2 and php7.2 Amazon Linux Extras repositories to get the latest versions of the LAMP MariaDB and PHP packages for Amazon Linux 2.
   `sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2`
4. Now that your instance is current, you can install the Apache web server, MariaDB, and PHP software packages.
   Note: I'm going to divert here.  The original steps say to install apache and DB locally: `sudo yum install -y httpd mariadb-server`
   a. I will install the DB on a different server, so I will only install apache locally:
   `sudo yum install -y httpd`
   b. Create RDS instance in Amazon Console.
   c. Connect RDS instance to EC2 instance.
   I should probably have created the DB instance through terraform...
5. Start the Apache web server.
   `[ec2-user ~]$ sudo systemctl start httpd`
6. Use the systemctl command to configure the Apache web server to start at each system boot.
   `[ec2-user ~]$ sudo systemctl enable httpd`
   You can verify that httpd is on by running the following command:
   `[ec2-user ~]$ sudo systemctl is-enabled httpd`
7. Add a security rule to allow inbound HTTP (port 80) connections to your instance if you have not already done so. By default, a launch-wizard-N security group was set up for your instance during initialization. This group contains a single rule to allow SSH connections.
   (done via terraform)
8. Test your web server. In a web browser, type the public DNS address (or the public IP address) of your instance. 
   ...
   To set file permissions
   Add your user (in this case, ec2-user) to the apache group.
   `sudo usermod -a -G apache ec2-user`
   Change the group ownership of /var/www and its contents to the apache group.
   `sudo chown -R ec2-user:apache /var/www`
   To add group write permissions and to set the group ID on future subdirectories, change the directory permissions of /var/www and its subdirectories.
   `sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;`
   To add group write permissions, recursively change the file permissions of /var/www and its subdirectories:
   `find /var/www -type f -exec sudo chmod 0664 {} \;`

### Setup SSL
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SSL-on-amazon-linux-2.html

Add TLS support by installing the Apache module mod_ssl.
`sudo yum install -y mod_ssl`

I followed all the instructions, using the Let's Encrypt certbot to enable SSL.  At the end, I got these important notes:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations! You have successfully enabled https://citizensforalibrary.org
and https://www.citizensforalibrary.org
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/citizensforalibrary.org/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/citizensforalibrary.org/privkey.pem
   Your certificate will expire on 2023-05-21. To obtain a new or
   tweaked version of this certificate in the future, simply run
   certbot again with the "certonly" option. To non-interactively
   renew *all* of your certificates, run "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

## Step 2: Test your LAMP server

1. Create a PHP file in the Apache document root.

`[ec2-user ~]$ echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php`

2. In a web browser, type the URL of the file that you just created. This URL is the public DNS address of your instance followed by a forward slash and the file name. For example:

`http://citizensforalibrary.org/phpinfo.php`

3. Delete the phpinfo.php file. Although this can be useful information, it should not be broadcast to the internet for security reasons.

`[ec2-user ~]$ rm /var/www/html/phpinfo.php`

4. Test mysql
   See https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.MySQL.html

   Install mariadb client (yes, use the mariadb client to connect to mysql DB)
   `sudo yum install mariadb`

   Connect using mysql client
   `mysql -h <output from rds_hostname>`
