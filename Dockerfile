FROM mkenney/php-base:php5

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

##############################################################################
# composer
##############################################################################

COPY container /container
ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION master
RUN mkdir /home/dev/composer \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g secure-http false \
    && cd /home/dev/composer \
    && chmod -R g+rw,o+rw . \
    && echo "xdebug.default_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini

ENTRYPOINT ["/as-user","/usr/local/bin/composer"]
