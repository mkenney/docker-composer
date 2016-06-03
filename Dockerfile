FROM alpine:latest

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

##############################################################################
# composer
##############################################################################

ENV COMPOSER_HOME /home/dev/.composer
ENV COMPOSER_VERSION master

RUN set -x \

    # Install required packages
    && apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        ca-certificates \
        curl \
        git \
        mercurial \
        openssh \
        shadow \
        subversion \
        sudo \
        php \
        php-curl \
        php-iconv \
        php-json \
        php-openssl \
        php-phar \
        php-posix \
        wget \

    # Create a dev user to use as the directory owner
    && groupadd dev \
    && useradd dev -s /bin/sh -m -g dev -G root \
    && echo "dev:password" | chpasswd \

    # Install composer
    && mkdir /home/dev/.composer \
    && echo "PATH=\$PATH:/home/dev/.composer/vendor/bin" > /home/dev/.profile \
    && chmod -R 0755 /home/dev \
    && chown -R dev:dev /home/dev \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && sudo -u dev /usr/local/bin/composer config -g secure-http false

# Setup wrapper scripts
COPY container/as-user /as-user
COPY container/composer-wrapper /composer-wrapper
RUN chmod 0755 /as-user \
    && chmod 0755 /composer-wrapper

VOLUME /src
WORKDIR /src

ENTRYPOINT ["/as-user","/composer-wrapper"]
