#-----------------------------------------------------------------------------------------------------#   
# use the official Docker container
#
# official container 
#     * deploys the build from the apache.org downloads page
#     * does not come with the supporting tools to configure the webservice as in a Debian distribution
#     * make logs only accessible via the docker logs streams, so no persistence
# 
# This Docker configuration is a minor adaptation to the Official container setup. 
# Extra steps are in the layers for documenentation purpose
#-----------------------------------------------------------------------------------------------------#   
#FROM httpd:2.4
# use a variant of the official HTTPD container build on Debian Stretch
# this is temporary until the official moves to it
#FROM solsson/httpd-stretch
FROM ruby:3.2-bullseye

# install additional software
RUN apt-get update \
    && apt-get install -y curl vim \
    && apt-get install -y apache2

RUN gem install --no-user-install linkeddata

RUN a2enmod proxy setenvif log_debug cgi proxy proxy_http rewrite env status
RUN a2dissite 000-default


RUN apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && apt-get clean  \ 
    && rm -rf /var/lib/apt/lists/*

# make logs persistent in /logs
RUN mkdir -p /logs \
    && chown -R www-data:www-data /logs \
    && chmod -R 666 /logs

# config directory holds the configuration
ADD config /config
ENV PATH /config/bin:$PATH
    # activates the necessary modules
COPY config/apache2.conf /etc/apache2/apache2.conf
    # vhosts configuration:
    # aliases /scripts with cgi-bin
    # sets logs to point to /logs
COPY config/mods-enabled/*.conf /etc/apache2/mods-enabled/
COPY config/conf-enabled/*.conf /etc/apache2/conf-enabled/
COPY config/httpd-vhosts.conf /etc/apache2/sites-available/ldsb.conf
RUN a2ensite ldsb.conf



# scripts directory is the cgi-bin for the config
ADD scripts /scripts
RUN chmod -R 555 /scripts && mkdir -p /scripts/tmp && chmod 666 /scripts/tmp

# www directory holds the document root
ADD www /www
RUN rm -rf /var/www && ln -s /www /var/www
#RUN rm -rf /usr/local/apache2/htdocs && ln -s /www /usr/local/apache2/htdocs
RUN mkdir -p /www/tmp && chmod 777 /www/tmp


# Default Environment Variable assignments
# these values can be overwritten at runtime

ENV ENV_SERVERNAME ldsb-data.vlaanderen.be
ENV ENV_URI_PREFIX https://data.vlaanderen.be
ENV ENV_URI_DOMAIN data.vlaanderen.be
ENV ENV_SPARQL_ENDPOINT_SERVICE_URL http://sparql-endpoint-service:8890/sparql
ENV ENV_QUERY direct_with_anonskolem_level1_and_concept.rq
ENV ENV_CONTEXTMAP file:///config/context.map
ENV ENV_LOGLOCAL false


#RUN chown -R www-data:www-data /scripts \
#   && chown -R www-data:www-data /www \
#   && chown -R www-data:www-data /etc/apache2 \
#   && chown -R www-data:www-data /var/log/apache2 

#USER www-data



# redefine the start of the service to be incorporate the runtime configuration 
# of environment variables
# ENTRYPOINT ["/config/bin/start.sh"]
CMD ["/config/bin/start.sh"]
