#!/bin/bash

TEMPLATE=$1 
SUBJECT=$2
#SPARQLENDPOINT=http://13.69.8.72:8891/sparql
SPARQLENDPOINT=ENV_SPARQL_ENDPOINT_SERVICE_URL
TMP=$3
if [ "$TMP" = "" ] ; then
   TMP=/scripts/tmp
fi

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

if [ $? -eq 0 ] ; then
rdf serialize --input-format turtle --output-format ntriples -o $TMP/subject.nt $TMP/subject.ttl 
fi

if [ ! -s $TMP/subject.nt ] ; then
   rm -f $TMP/subject.nt
   rm -f $TMP/subject.ttl
   rm -rf $TMP
fi

# cleanup $TMP
rm -f $TMP/template.rq

