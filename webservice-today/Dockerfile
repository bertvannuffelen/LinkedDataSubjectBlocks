#FROM webdevops/apache:debian-9
#  > creates an eternal loop
FROM eboraas/apache

RUN apt-get update && apt-get -y install curl raptor2-utils && apt-get clean  && rm -rf /var/lib/apt/lists/*

ADD config /config
ADD www /www
ADD scripts /scripts
ENV WEB_DOCUMENT_ROOT=/www

RUN a2enmod rewrite && a2enmod proxy && a2enmod cgi  && a2enmod env

RUN cp /config/*.conf /etc/apache2/conf-enabled/
RUN mkdir -p /www/tmp && chmod 777 /www/tmp
RUN chmod -R 777 /scripts

