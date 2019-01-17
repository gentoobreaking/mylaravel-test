#!/bin/sh

docker exec -i mylaravel2 /bin/bash << EOF
mkdir /var/www/storage/framework/sessions
chown -R www-data:www-data /var/www/
chown -R www-data:www-data /var/www/public /var/www/storage /var/www/bootstrap
chmod -R 777 /var/www/public /var/www/storage /var/www/bootstrap /var/www/storage/framework/sessions
cd /var/www/
composer install
php artisan cache:clear
php artisan migrate:fresh
npm install
npm run prod
EOF

