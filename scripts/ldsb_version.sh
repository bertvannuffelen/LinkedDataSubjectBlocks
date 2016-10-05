#!/bin/bash
#set -x

DATESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`
LDSB=/tmp/version/LDSB$DATESTAMP

# assume the first argument is the FILE
FILE=$1
if [ "$FILE" = "" ] ; then
  exit 0
fi

# derive the most recent version from a given URI
#get_version_from_url() {
#  cd $LDSB
#  curl $FILE -o LDSB.tgz 
#  tar -ztf LDSB.tgz >> /dev/null
#  if [ $? -eq 0 ] ; then
#    echo "valid LDSB"
#    tar -zxvf LDSB.tgz version
#    source version
#    echo $VERSION
#  else
#    echo "invalid LDSB, returning a 404"
#    exit 1
#    # log this in log environment
#  fi
#
#}

# derive version from a given LDSB file (absolute path)
get_version_from_file() {
  cd $LDSB
  cp $FILE LDSB.tgz 
  tar -ztf LDSB.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    tar -zxf LDSB.tgz version
    source version
    echo $VERSION
  else
    exit 1
    # echo "invalid LDSB, returning a 404"
    # log this in log environment
  fi


}

mkdir -p $LDSB
get_version_from_file
