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

# assume the second argument is the version number
TARGETVERSION=$2
if [ "$TARGETVERSION" = "" ] ; then
  exit 0
fi

get_nth_version() {
  tar -ztf LDSB.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    echo "valid LDSB"
    tar -zxvf LDSB.tgz version
    source version
    if [ $VERSION = $TARGETVERSION ] ; then
    	tar -zxvf LDSB.tgz subject.nt
    else 
	if [ $VERSION < 0 || $VERSION < $TARGETVERSION ] ; then 
	 echo "version not in the LDSB chain, returning a 404"
    	 # log this in log environment
        else
         mv LDSB_prev.tgz LDSB.tgz
	 get_nth_version
	fi

    fi
  else
    echo "invalid LDSB, returning a 404"
    # log this in log environment
  fi

}

get_nth_version_init() {
  cd $LDSB
  curl $SUBJECT_LDSB -o LDSB.tgz 
  get_nth_version
}


get_nth_version_init
