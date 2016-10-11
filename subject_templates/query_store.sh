#!/bin/bash

ROQET=roqet

TEMPLATE=$1 
SUBJECT=$2
SPARQLENDPOINT=http://dbpedia.org/sparql

cp $TEMPLATE /tmp/template.rq
sed -i "s SUBJECT $2 g" /tmp/template.rq 

QUERY=`cat /tmp/template.rq`

$ROQET -i sparql -p $SPARQLENDPOINT -r ntriples -e "$QUERY"

# cleanup tmp
rm /tmp/template.rq

