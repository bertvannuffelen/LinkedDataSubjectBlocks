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

| Environment variable | default value | comment |
| -------------------- | ------------- | --------|
| ENV_URI_PREFIX | https://data.vlaanderen.be | use prefix to cope with http/https issue 
| ENV_URI_DOMAIN | data.vlaanderen.be | deprecated over ENV_URI_PREFIX
| ENV_SPARQL_VIRTUOSO | | a setting with allows to customize the sparql-template for Virtuoso. Example see below.
| ENV_SERVERNAME | ldsb-data.vlaanderen.be |
| ENV_LOGLOCAL   | false | set true to log on disk
| ENV_CONTEXTMAP | file:///config/context.map| a mapping between the concepts and their jsonld context definition


###Example ENV_SPARQL_VIRTUOSO

This environment variable is a placeholder at the start of a SPARQL template.
Virtuoso has the ability to configure the scope of the query by virtuoso specific constructs. This variable allows
to insert statements of the following form.
```
ENV_SPARQL_VIRTUOSO define input:default-graph-exclude <http://data.vlaanderen.be/id/dataset/muuuid>
```




Building & Development statements
=================================
Assume docker is installed.


Let LOCALDIR be this directory.

`` docker build . -t subjectblocks``

starts the service name ldsb
``
   docker run -p81:80 -d --name ldsb \
   -v /home/vagrant/OSLO/github/LinkedDataSubjectBlocks/webservice-today/logs:/logs \
   --add-host sparql-endpoint-service:13.93.84.96 
   subjectblocks 
``

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


Operational considerations
==========================
disk-space
----------
The system will write data to `/www/tmp/` to store the LDSB. There has been no disk cleanup implemented.
