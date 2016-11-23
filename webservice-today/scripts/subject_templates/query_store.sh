#!/bin/bash

TEMPLATE=$1 
SUBJECT=$2
#SPARQLENDPOINT=http://dbpedia.org/sparql
SPARQLENDPOINT=http://13.93.84.96:8890/sparql
TMP=/scripts/tmp

DOCUMENT=${SUBJECT/id/doc}
DATESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`

cp $TEMPLATE $TMP/template.rq
sed -i "s SUBJECT $SUBJECT g" $TMP/template.rq 
sed -i "s DOCUMENT $DOCUMENT g" $TMP/template.rq 
sed -i "s NOW $DATESTAMP g" $TMP/template.rq 

QUERY=`cat $TMP/template.rq`

# roqet does not react properly
# ROQET=roqet
# $ROQET -i sparql -p $SPARQLENDPOINT -r turtle -e "$QUERY"

curl -H "Accept: text/turtle" \
    --data-urlencode query="$QUERY" \
    -o $TMP/subject.ttl \
   $SPARQLENDPOINT

rapper -i turtle -o ntriples $TMP/subject.ttl > subject.nt

# cleanup $TMP
rm $TMP/template.rq

