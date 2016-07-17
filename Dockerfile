FROM alpine:latest

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

##############################################################################
# composer
##############################################################################

ENV COMPOSER_HOME /home/dev/.composer
ENV COMPOSER_VERSION master

RUN set -x \
    && apk update \

    # Install required packages
    && apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        ca-certificates \
        curl \
        git \
        mercurial \
        openssh \
        subversion \
        sudo \
        php5 \
        php5-curl \
        php5-iconv \
        php5-json \
        php5-openssl \
        php5-phar \
        php5-posix \
        wget \

    # Create a dev user to use as the directory owner
    && addgroup dev \
    && adduser -D -s /bin/sh -G dev -G root dev \
    && echo "dev:password" | chpasswd \

    # Install composer
    && mkdir /home/dev/.composer \
    && echo "PATH=\$PATH:/home/dev/.composer/vendor/bin" > /home/dev/.profile \
    && chmod -R 0755 /home/dev \
    && chown -R dev:dev /home/dev \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && sudo -u dev /usr/local/bin/composer config -g secure-http false \

    # Setup wrapper scripts
    && wget -O /run-as-user https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/run-as-user \
    && wget -O /composer-wrapper https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/composer-wrapper \
    && chmod 0755 /run-as-user \
    && chmod 0755 /composer-wrapper

VOLUME /src
WORKDIR /src

ENTRYPOINT ["/run-as-user", "/composer-wrapper"]
