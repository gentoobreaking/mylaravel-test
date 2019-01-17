FROM php:alpine
LABEL maintainer="gentoobreaking <gentoobreaking@gmail.com>"

# Comment this to improve stability on "auto deploy" environments
RUN apk update && apk upgrade

# Install basic dependencies
RUN apk -u add bash git

# Install PHP extensions
ADD install-php.sh /usr/sbin/install-php.sh
ENV XDEBUG_VERSION 2.6.1
RUN /usr/sbin/install-php.sh

RUN mkdir -p /etc/ssl/certs && update-ca-certificates

# Download and install NodeJS
ADD install-node.sh /usr/sbin/install-node.sh
RUN /usr/sbin/install-node.sh

WORKDIR /var/www
#CMD ["/usr/local/bin/php"]
CMD php ./artisan serve --port=80 --host=0.0.0.0
EXPOSE 80
HEALTHCHECK --interval=1m CMD curl -f http://localhost/ || exit 1

# --- END --- #
