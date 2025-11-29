#!/bin/bash
# Basic bootstrap: update, install httpd and start
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

# Create a simple index page showing environment
cat > /var/www/html/index.html <<'HTML'
<html>
  <head><title>Terraform Demo</title></head>
  <body>
    <h1>Terraform VPC Project - Web Server</h1>
    <p>Environment: dev (replace as needed)</p>
    <p>Deployed by: Terraform</p>
  </body>
</html>
HTML



