#!/bin/bash
set -x

DATESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`
LDSB=/tmp/LDSB$DATESTAMP

# assume the first argument is the subject URI
SUBJECT=$1
if [ "$SUBJECT" = "" ] ; then
  exit 0
fi
SUBJECT_LDSB="$SUBJECT"

# derive the most recent version from a given URI
get_subject() {
  cd $LDSB
  curl $SUBJECT_LDSB -o LDSB.tgz 
  tar -ztf LDSB.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    echo "valid LDSB"
    tar -zxvf LDSB.tgz subject.nt
  else
    echo "invalid LDSB, returning a 404"
    # log this in log environment
  fi

}
