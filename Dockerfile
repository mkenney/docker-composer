FROM php:7-cli

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

# System update
RUN apt-get -q -y update

# Because some basic tools come in handy...
RUN apt-get install -q -y less

# Packages
RUN apt-get install -q -y libfreetype6-dev
RUN apt-get install -q -y libjpeg62-turbo-dev
RUN apt-get install -q -y libmcrypt-dev
RUN apt-get install -q -y libpng12-dev
RUN apt-get install -q -y libbz2-dev
RUN apt-get install -q -y php-pear
RUN apt-get install -q -y curl
RUN apt-get install -q -y git
RUN apt-get install -q -y subversion
RUN apt-get install -q -y unzip
RUN apt-get clean && rm -r /var/lib/apt/lists/*

# PHP Extensions and configurations
RUN docker-php-ext-install mcrypt zip bz2 mbstring
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Composer home
ENV COMPOSER_HOME /root/composer

# Set up the application directory
VOLUME ["/app"]
WORKDIR /app
ENV TERM xterm

# Install Composer
ENV COMPOSER_VERSION master
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT ["/usr/local/bin/composer"]
