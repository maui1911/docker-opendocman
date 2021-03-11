FROM php:7.4-apache
LABEL maintainer=maui1911

ENV HOME /root
WORKDIR ${HOME}

# Install packages
RUN apt-get update \
  && apt-get install --no-install-recommends -y apt-utils vim git openssl ssl-cert sendmail default-mysql-client \
  && docker-php-ext-install pdo_mysql pdo \
  && rm -rf /var/lib/apt/lists/*

#get code
RUN git clone https://github.com/opendocman/opendocman.git 
WORKDIR ${HOME}/opendocman
# Copy php configs
#COPY src/main/resources/docker-php-pecl-install /usr/local/bin/
#RUN docker-php-pecl-install xdebug-2.3.3
#COPY src/main/resources/xdebug.ini ${PHP_INI_DIR}/conf.d/docker-php-pecl-xdebug.ini
COPY src/main/resources/php.ini /usr/local/etc/php/conf.d

# Install mod_rewrite
RUN a2enmod rewrite
RUN a2ensite default-ssl
RUN a2enmod ssl

# Copy application files
COPY . /var/www/html

# Change file permissions
RUN usermod -u 1000 www-data

# Copy startup command
COPY src/main/resources/*.sh /
RUN chmod 755 /*.sh

EXPOSE 80 443

# By default, simply start apache.
ENTRYPOINT ["/start.sh"]