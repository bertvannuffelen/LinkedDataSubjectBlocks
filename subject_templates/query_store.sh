#!/bin/bash
set -x



TEMPLATE=$1 
SUBJECT=$2
SPARQLENDPOINT=http://dbpedia.org/sparql

cp $TEMPLATE /tmp/template.rq
sed -i "s SUBJECT $2 g" /tmp/template.rq 

QUERY=`cat /tmp/template.rq`

# roqet does not react properly
# ROQET=roqet
# $ROQET -i sparql -p $SPARQLENDPOINT -r turtle -e "$QUERY"

curl -H "Accept: text/turtle" \
    --data-urlencode query="$QUERY" \
    -o subject.ttl \
   $SPARQLENDPOINT

# cleanup tmp
rm /tmp/template.rq

