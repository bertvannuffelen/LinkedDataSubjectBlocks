FROM bertvannuffelen/testserver:latest

EXPOSE 80

COPY Caddyfile.test /config/Caddyfile
ADD configure_start.sh configure_start.sh

RUN chmod 777 configure_start.sh 


RUN apk --update add ca-certificates

#CMD ["/caddy", "-conf", "/config/Caddyfile", "-agree"]
CMD ["./configure_start.sh" ]
