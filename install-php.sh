#!/bin/sh

Install_Basic_Packages()
{
apk add file re2c freetds freetype icu libintl libldap libjpeg libmcrypt libpng libpq libwebp

TMP="autoconf \
    curl-dev \
    freetds-dev \
    freetype-dev \
    g++ \
    gcc \
    gettext-dev \
    icu-dev \
    jpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    make \
    openldap-dev \
    postgresql-dev"
apk add $TMP
}

Configure_extensions()
{
docker-php-ext-configure gd --with-jpeg-dir=usr/ --with-freetype-dir=usr/ --with-webp-dir=usr/
docker-php-ext-configure ldap --with-libdir=lib/
docker-php-ext-configure pdo_dblib --with-libdir=lib/
}

Download_mongo_extension()
{
cd /tmp && \
    git clone https://github.com/mongodb/mongo-php-driver.git && \
    cd mongo-php-driver && \
    git submodule update --init && \
    phpize && \
    ./configure --with-mongodb-ssl=libressl && \
    make all && \
    make install && \
    echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini && \
    rm -rf /tmp/mongo-php-driver
}

Install_php_ext()
{
docker-php-ext-install \
    curl \
    exif \
    gd \
    gettext \
    intl \
    ldap \
    pdo_dblib \
    pdo_mysql \
    pdo_pgsql \
    xmlrpc \
    zip
}

Download_trusted_certs()
{
mkdir -p /etc/ssl/certs && update-ca-certificates
}

Install_composer()
{
cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
   mv composer.phar /usr/bin/composer && \
   chmod +x /usr/bin/composer
}

Install_Xdebug()
{
curl -sSL -o /tmp/xdebug-${XDEBUG_VERSION}.tgz http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz
cd /tmp && tar -xzf xdebug-${XDEBUG_VERSION}.tgz && cd xdebug-${XDEBUG_VERSION} && phpize && ./configure && make && make install
echo "zend_extension=xdebug" > /usr/local/etc/php/conf.d/xdebug.ini
rm -rf /tmp/xdebug*
}

Delete_Package()
{
apk del $TMP
}

Install_PHPUnit()
{
curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit
}

Set_timezone()
{
echo America/Maceio > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
}

Install_Basic_Packages
Configure_extensions
#Download_mongo_extension
Install_php_ext
Download_trusted_certs
Install_composer
#Install_Xdebug
Delete_Package
Install_PHPUnit
#Set_timezone

# --- END --- #
