FROM mkenney/php-base

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

##############################################################################
# composer
##############################################################################

ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION master
ENV XDEBUG_CONF /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN set -x \
    && mkdir /root/composer \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g secure-http false \
    && cd /root/composer \
    && chmod -R 0777 . \

    # Disable xdebug
    && echo ""                         >  ${XDEBUG_CONF} \
    && echo "xdebug.default_enable=0"  >> ${XDEBUG_CONF} \
    && echo "xdebug.remote_enable=0"   >> ${XDEBUG_CONF} \
    && echo "xdebug.profiler_enable=0" >> ${XDEBUG_CONF}

ENTRYPOINT ["/as-user","/usr/local/bin/composer"]
