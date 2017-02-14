Webservice today
================

This container offers Linked Data Subject pages based on a sparql endpoint based on the 
current view of the item. It does not support chains as a Linked Data Subject Block chain is intended to do.
However, it implements the urls that are to be supported to retrieve the information in different serializations.


## Architectural embedding
The service connects to other services, which should be declared as accessible hosts:

* sparql-endpoint-service : SPARQL endpoint

The service URLs are given by the following environment variables

| Environment variable | default value |
| -------------------- | ------------- |
| ENV_SPARQL_ENDPOINT_SERVICE_URL    | http://sparql-endpoint-service:8890/sparql |

## Configuration

| Environment variable | default value |
| -------------------- | ------------- |
| ENV_URI_DOMAIN | data.vlaanderen.be |
| ENV_SERVERNAME | ldsb-data.vlaanderen.be |


Building & Development statements
=================================
Assume docker is installed.


Let LOCALDIR be this directory.

`` docker build . -t ldsb-proxy ``

starts the service name ldsb
``docker run --rm -p 80:80 -v $LOCALDIR/scripts:/scripts --name=ldsb ldsb-proxy ``

quickest way to stop the service
``docker exec -it ldsb service apache2 stop ``

tail the error log
``docker exec ldsb tail -f /var/log/apache2/error.log``


test examples
-------------
curl http://data.vlaanderen.be/id/address/1111.lsdb
curl http://data.vlaanderen.be/id/address/1111.latest_version
curl http://data.vlaanderen.be/id/address/1111.lsdb_v0
curl http://data.vlaanderen.be/id/address/1111.lsdb_v1
curl http://data.vlaanderen.be/id/address/1111.lsdb_v2
curl http://data.vlaanderen.be/id/address/1111.subject
curl -L http://data.vlaanderen.be/id/address/1111.subject
curl -L http://data.vlaanderen.be/id/address/1111.subject_nt
curl -L http://data.vlaanderen.be/id/address/1111.subject_ttl
curl -L http://data.vlaanderen.be/id/address/1111.subject_rdf


