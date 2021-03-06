#!/bin/bash

TEMPLATE=$1 
SUBJECT=$2
#SPARQLENDPOINT=http://dbpedia.org/sparql
SPARQLENDPOINT=http://13.93.84.96:8890/sparql

DOCUMENT=${SUBJECT/id/doc}
DATESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`

cp $TEMPLATE /tmp/template.rq
sed -i "s SUBJECT $SUBJECT g" /tmp/template.rq 
sed -i "s DOCUMENT $DOCUMENT g" /tmp/template.rq 
sed -i "s NOW $DATESTAMP g" /tmp/template.rq 

QUERY=`cat /tmp/template.rq`

# roqet does not react properly
# ROQET=roqet
# $ROQET -i sparql -p $SPARQLENDPOINT -r turtle -e "$QUERY"

curl -H "Accept: text/turtle" \
    --data-urlencode query="$QUERY" \
    -o /tmp/subject.ttl \
   $SPARQLENDPOINT

rapper -i turtle -o ntriples /tmp/subject.ttl > subject.nt

# cleanup tmp
rm /tmp/template.rq

