##############################################################################
# composer php5
##############################################################################
FROM php:5-cli-alpine

LABEL org.label-schema.schema-version=1.0 \
    org.label-schema.vendor=bdlm@webbedlam.com \
    org.label-schema.vcs-url=https://github.com/mkenney/docker-composer \
    org.label-schema.description="This image provides the composer build tool for PHP." \
    org.label-schema.name="Composer" \
    org.label-schema.url=https://github.com/mkenney/docker-composer

ENV COMPOSER_HOME /home/dev/.composer
ENV COMPOSER_VERSION master

# Install required packages
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk add \
        ca-certificates \
        curl \
        curl-dev \
        git \
        libcrypto1.0 \
        libmcrypt \
        libmcrypt-dev \
        libressl-dev \
        m4 \
        mercurial \
        openssh \
        shadow \
        subversion \
        sudo \
        wget

# Configure PHP packages
RUN docker-php-ext-configure mcrypt \
        --with-mcrypt \
    && docker-php-ext-install \
        curl \
        iconv \
        json \
        mcrypt \
        phar \
        posix

# Create a dev user to use as the directory owner
RUN addgroup dev \
    && adduser -D -s /bin/sh -G dev dev \
    && echo "dev:password" | chpasswd

# Install composer
RUN mkdir /home/dev/.composer \
    && echo "PATH=\$PATH:/home/dev/.composer/vendor/bin" > /home/dev/.profile \
    && echo "cd /src" >> /home/dev/.profile \
    && chmod -R 0755 /home/dev \
    && chown -R dev:dev /home/dev \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && sudo -u dev /usr/local/bin/composer config -g secure-http false \
    && composer self-update

# Setup wrapper scripts
RUN wget -O /run-as-user https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/run-as-user \
    && wget -O /composer-wrapper https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/composer-wrapper \
    && chmod 0755 /run-as-user \
    && chmod 0755 /composer-wrapper

VOLUME /src
WORKDIR /src

ENTRYPOINT ["/run-as-user", "/composer-wrapper"]
