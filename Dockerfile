FROM alpine:3.3

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

##############################################################################
# composer
##############################################################################

COPY container/as-user /as-user
COPY container/composer-wrapper /composer-wrapper

ENV COMPOSER_HOME /dev/composer
ENV COMPOSER_VERSION master

VOLUME /src
WORKDIR /src

RUN set -x \

    # Install required packages
    && apk add --no-cache  --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        ca-certificates \
        git \
        mercurial \
        openssh \
        shadow \
        subversion \
        sudo \
        php7 \
        php7-curl \
        php7-iconv \
        php7-json \
        php7-openssl \
        php7-phar \
        php7-posix \
        wget \

    # Link so that the wrapper script works for both versions
    && ln -s /usr/bin/php7 /usr/bin/php \

    # Create a dev user to use as the directory owner
    && groupadd dev \
    && useradd dev -s /bin/bash -m -g dev -G root \
    && echo "dev:password" | chpasswd \
    && chmod 0777 /home/dev \

    # Install composer
    && mkdir /dev/composer \
    && chmod -R 0777 /dev/composer \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && sudo -u dev /usr/local/bin/composer config -g secure-http false \

    # Make sure it all runs
    && chmod 0755 /as-user \
    && chmod 0755 /composer-wrapper

ENTRYPOINT ["/as-user","/composer-wrapper"]
