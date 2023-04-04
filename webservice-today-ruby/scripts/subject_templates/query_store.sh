#!/bin/bash

TEMPLATE=$1 
SUBJECT=$2
SPARQLENDPOINT=ENV_SPARQL_ENDPOINT_SERVICE_URL

export PATH=$PATH:/usr/local/bundle/bin
#export RUBY_VERSION=3.2.1
export BUNDLE_APP_CONFIG=/usr/local/bundle
#export RUBY_MAJOR=3.2
#HOME=/root
#export LANG=C.UTF-8
export BUNDLE_SILENCE_ROOT_WARNING=1
export GEM_HOME=/usr/local/bundle

RDFGEM=/usr/local/bundle/bin/rdf

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

