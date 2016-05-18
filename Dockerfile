FROM mkenney/php-base:php5

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

##############################################################################
# composer
##############################################################################

ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION master
RUN mkdir /root/composer \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g secure-http false \
    && cd /root/composer \
    && chmod -R g+rw,o+rw .
ENV PATH /root/.composer/vendor/bin:$PATH

ENTRYPOINT ["/usr/local/bin/composer"]
