FROM php:7-alpine

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

##############################################################################
# composer
##############################################################################

ENV COMPOSER_HOME /home/dev/.composer
ENV COMPOSER_VERSION master

RUN set -x \

    # Install required packages
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk add \
        ca-certificates \
        curl \
        curl-dev \
        git \
        libcrypto1.0 \
        m4 \
        mercurial \
        openssh \
        openssl-dev \
        shadow \
        subversion \
        sudo \
        wget

RUN set -x \
    && docker-php-ext-install \
        curl \
        iconv \
        json \
        phar \
        posix

    # Create a dev user to use as the directory owner
RUN set -x \
    && addgroup dev \
    && adduser -D -s /bin/sh -G dev dev \
    && echo "dev:password" | chpasswd \

    # Install composer
    && mkdir /home/dev/.composer \
    && echo "PATH=\$PATH:/home/dev/.composer/vendor/bin" > /home/dev/.profile \
    && chmod -R 0755 /home/dev \
    && chown -R dev:dev /home/dev \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && sudo -u dev /usr/local/bin/composer config -g secure-http false \
    && composer self-update \

    # Setup wrapper scripts
    && wget -O /run-as-user https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/run-as-user \
    && wget -O /composer-wrapper https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/composer-wrapper \
    && wget -O /set-ssh-key-perms https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/set-ssh-key-perms \
    && chmod 0755 /run-as-user \
    && chmod 0755 /composer-wrapper \
    && chmod 0755 /set-ssh-key-perms

VOLUME /src
WORKDIR /src

ENTRYPOINT ["/set-ssh-key-perms", "/run-as-user", "/composer-wrapper"]
