#!/bin/bash 
set -x

# This scripts creates a LDSB for a subject 
# using standard Linux/Unix tools

DATESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`
LDSB=/tmp/LDSB$DATESTAMP
LDSB_filename=LDSB.tgz
VERSION_filename=version

# assume the first argument is the subject URI
SUBJECT=$1
if [ "$SUBJECT" = "" ] ; then
  exit 0
fi
UnversionedDOCUMENT=${SUBJECT/id/doc}

SUBJECT_LDSB="$SUBJECT.ldsb"


create_subject_file() {
  cd $LDSB
  touch subject.nt
}

create_version_file() {
  cd $LDSB

  DOCUMENT="$UnversionedDOCUMENT.ldsb_v$VERSION"
  touch $VERSION_filename
  echo "SUBJECT=$SUBJECT" >> $VERSION_filename
  echo "VERSION=$VERSION" >> $VERSION_filename
  echo "DOCUMENT=$DOCUMENT" >> $VERSION_filename
  echo "ISSUED=$DATESTAMP" >> $VERSION_filename
  # for each URI get the current DOCVERSION 
  echo "MAP=\"$URI||$DOCVERSION\"" >> $VERSION_filename

}

create_previous_LDSB() {
  cd $LDSB
  wget $SUBJECT_LDSB -O LDSB_prev.tgz 
  tar -ztf LDSB_prev.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    echo "valid LDSB"
    PREVVERSION=`ldsb_version.sh file:///$LDSB/LDSB_prev.tgz`
    VERSION=$((PREVVERSION+1))
  else
    echo "invalid LDSB, generating empty version "
    VERSION=0
    # log this in log environment
  fi
}

fold_LDSB() {
  cd $LDSB
  tar -czf $LDSB_filename *
}


create_ldsb() {
  mkdir -p $LDSB
  create_subject_file
  create_previous_LDSB
  create_version_file
  fold_LDSB

  # define the output as the pointer to the location of the file 
  FILE="file://$LDSB/$LDSB_filename"

}

create_ldsb
echo $FILE
exit 0

