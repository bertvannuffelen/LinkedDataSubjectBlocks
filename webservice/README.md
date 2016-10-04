Building & Development statements
=================================
Assume docker is installed.


Let LOCALDIR be this directory.


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


