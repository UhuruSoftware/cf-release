# abort script on any command that exit with a non zero value
set -e

# from http://pcre.org/
# wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.21.tar.gz

# get the apache server
# wget -nc http://mirrors.hostingromania.ro/apache.org//httpd/httpd-2.4.3.tar.gz
# wget -nc http://mirrors.hostingromania.ro/apache.org//httpd/httpd-2.4.3-deps.tar.gz

# from http://php.net
wget -nc http://ro1.php.net/distributions/php-5.4.11.tar.gz

# get the he apache server
wget -nc http://mirrors.hostingromania.ro/apache.org//httpd/httpd-2.2.23.tar.gz

# from http://php.net
wget -nc http://ro1.php.net/distributions/php-5.3.21.tar.gz

# get Autotools for pecl
wget -nc http://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz
wget -nc http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
wget -nc http://ftp.gnu.org/gnu/automake/automake-1.13.1.tar.gz

# dependency for mssql service
# from ftp://ftp.freetds.org/pub/freetds/stable/
wget -nc ftp://ftp.freetds.org/pub/freetds/stable/freetds-0.91.tar.gz

# dependency for redis
# form https://github.com/nicolasff/phpredis/tags
wget -nc https://github.com/nicolasff/phpredis/archive/2.2.2.tar.gz --output-document phpredis-2.2.2.tar.gz

mkdir -p pecl
cd pecl

wget -nc http://pecl.php.net/get/APC-3.1.13.tgz
wget -nc http://pecl.php.net/get/memcache-2.2.7.tgz # memcache service
wget -nc http://pecl.php.net/get/timezonedb-2012.10.tgz
# not working with bosh imagemagic packag
# wget -nc http://pecl.php.net/get/imagick-3.1.0RC2.tgz
wget -nc http://pecl.php.net/get/mongo-1.3.4.tgz # mongodb service
wget -nc http://pecl.php.net/get/uploadprogress-1.0.3.1.tgz
wget -nc http://pecl.php.net/get/xdebug-2.2.1.tgz
wget -nc http://pecl.php.net/get/mailparse-2.1.6.tgz
wget -nc http://pecl.php.net/get/zip-1.10.2.tgz
wget -nc http://pecl.php.net/get/pecl_http-1.7.4.tgz
# TODO. not working. install https://github.com/alanxz/rabbitmq-c first
# wget -nc http://pecl.php.net/get/amqp-1.0.9.tgz # rabbitmq service
wget -nc http://pecl.php.net/get/rar-3.0.1.tgz
wget -nc http://pecl.php.net/get/radius-1.2.5.tgz
wget -nc http://pecl.php.net/get/oauth-1.2.3.tgz
wget -nc http://pecl.php.net/get/bcompiler-1.0.2.tgz
wget -nc http://pecl.php.net/get/LZF-1.6.2.tgz

cd ..


