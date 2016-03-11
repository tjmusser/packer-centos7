#!/usr/bin/env bash
#
# This file is used to build a base box for Vagrant to use. The purpose is to
# install and configure the base set of software that is needed to run the
# application. Once the base box is created, it can be used as the starting
# point for provisioning an environment.
#
# The benefit of this process is that creating/recreating the Vagrant box
# is faster. Setting up the base box can take 10+ minutes.

#
# Soften root directory (required for postgresql step)
#

chmod o+rx /root

#
# Install Software
#

yum -y update
yum install -y wget python-devel vim epel-release httpd python-psycopg2 mod_wsgi gcc ntpdate freetype-devel libjpeg-turbo-devel libpng-devel xvfb
yum install -y npm
yum install -y python-pip

#
# Install newer git version, 2.7.0
#

sudo yum -y groupinstall "Development Tools"
sudo yum -y install gettext-devel curl-devel openssl-devel perl-CPAN perl-devel zlib-devel
wget https://github.com/git/git/archive/v2.7.0.tar.gz -O git.tar.gz
tar -zxf git.tar.gz
cd git-*

make configure
./configure --prefix=/usr --with-curl
sudo make install

git config --global color.ui auto

# Clean up files
rm -rf git.tar.gz
rm -rf git-*

#
# Instally Django and app packages
#

pip install Django==1.7.8 oauth2 pytz boto django-storages python-dateutil pillow django-ses django-simple-captcha tldextract django-pipeline awscli python-twitter twilio grequests django-test-without-migrations==0.4 factory_boy==2.6.1 mock==1.3.0
pip install --upgrade google-api-python-client
pip install --upgrade awsebcli
pip install --upgrade awscli

npm -g install yuglify

#
# Install Test dependencies
#

yum install -y xorg-x11-server-Xvfb firefox
pip install selenium pyvirtualdisplay
pip install django-south-compass

#
# Move configuration files
#

# File cleanup of existing files in apache conf
rm /etc/httpd/conf.d/*


#
# Install postgresql
#

rpm -Uvh http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm
yum install -y postgresql93 postgresql93-server postgresql93-contrib ntp
su - postgres -c /usr/pgsql-9.3/bin/initdb

echo "listen_addresses = '*'" >> /var/lib/pgsql/9.3/data/postgresql.conf
echo "port = 5432" >> /var/lib/pgsql/9.3/data/postgresql.conf

echo "host    all             all             0.0.0.0/0               trust" >> /var/lib/pgsql/9.3/data/pg_hba.conf

systemctl start postgresql-9.3.service
systemctl enable postgresql-9.3.service

su - postgres <<EOF
psql -c "CREATE ROLE root WITH SUPERUSER LOGIN PASSWORD 'b0unc3yt1m3';"
EOF

createdb youtily

aws s3 cp s3://youtily/sql/youtily.sql /tmp/youtily.sql
psql youtily < /tmp/youtily.sql

#
# Create symlink from vargrant synced folder to apache configuration folder
# Install Django-south-compass in repo
#

ln -s /vagrant/youtily /var/www/youtily
cd /vagrant
django-south-compass install

#
# Make a default html folder, prevent apache error
#
sudo mkdir -p /var/www/html
sudo mkdir /var/www/log
sudo chmod 0777 /var/www/log
sudo chmod 0777 /tmp/youtily.sql

sudo systemctl start httpd.service
sudo systemctl enable httpd.service

#
# Disable enforcing of SELinux
#

sed -i 's/enforcing/disabled/g' /etc/selinux/config


