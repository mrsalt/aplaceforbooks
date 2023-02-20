# Purpose

This repository will contain the code to support a website that will include a petition focused in a local area.

# Server Install

See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html.

1. Connect to your instance.  `ssh ec2-user@<public IP>`
2. Update packages.  `sudo yum update -y`
3. Install the lamp-mariadb10.2-php7.2 and php7.2 Amazon Linux Extras repositories to get the latest versions of the LAMP MariaDB and PHP packages for Amazon Linux 2.
   `sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2`
4. Now that your instance is current, you can install the Apache web server, MariaDB, and PHP software packages.
   Note: I'm going to divert here.  The original steps say to install apache and DB locally: `sudo yum install -y httpd mariadb-server`
   I will install the DB on a different server.
   `sudo yum install -y httpd`