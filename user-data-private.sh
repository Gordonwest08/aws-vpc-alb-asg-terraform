#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo "<h1>Private EC2 Web Server - ${HOSTNAME}</h1>" > /var/www/html/index.html
