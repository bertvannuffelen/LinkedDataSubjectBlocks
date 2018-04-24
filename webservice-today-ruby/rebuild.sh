#!/bin/bash

sudo docker build -t ldsb .

sudo docker stop ldsb1 ;  sudo docker rm ldsb1

#     -v /home/vagrant/OSLO/github/LinkedDataSubjectBlocks/log:/logs \
sudo docker run -p81:80 -d --name ldsb1 \
     -e ENV_LDSB_SERVICE_URL=http://ikke/ \
     -e ENV_SPARQL_ENDPOINT_SERVICE_URL=http://13.69.8.72:8891/sparql \
     ldsb -k start

