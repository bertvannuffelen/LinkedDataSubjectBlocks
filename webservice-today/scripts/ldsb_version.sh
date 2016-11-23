#!/bin/bash
set -x

#DATESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`
#caching per day
DATESTAMP=`date +%Y-%m-%d`

# assume the first argument is the subject URI
SUBJECT=$filepath
if [ "$SUBJECT" = "" ] ; then
  exit 0
fi
SUBJECT_LDSB="file:///www/storage/$SUBJECT/LDSB.tgz"
LDSB="/www/tmp/$DATESTAMP/$SUBJECT"

# derive the most recent version from a given URI
get_version() {
  cd $LDSB
  curl -s $SUBJECT_LDSB -o LDSB.tgz 
  tar -ztf LDSB.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    tar -zxf LDSB.tgz version
    source version
    SUCCESS=0
  else
    # echo "invalid LDSB, returning a 404"
    # log this in log environment
    SUCCESS=1
  fi

}

# derive version from a given LDSB file
get_version_from_file() {
  cd $LDSB
  wget $SUBJECT_LDSB -O LDSB.tgz 
  tar -ztf LDSB.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    echo "valid LDSB"
    tar -zxvf LDSB.tgz version
    source version
    echo $VERSION
  else
    echo "invalid LDSB, returning a 404"
    # log this in log environment
  fi


}

mkdir -p $LDSB
get_version

#echo $TARGET >> /var/log/apache2/ldsb_error.log

echo "Content-type: text/html"
if [ $SUCCESS == 0 ] ; then
   echo "Status: 200 OK"
else
   echo "Status: 404 NOT FOUND"
fi
echo ""
echo '<html>'
echo '<head>'
echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
echo '<title>VERSION</title>'
echo '</head>'
echo '<body>'
if [ $SUCCESS == 0 ] ; then
   echo "$VERSION"
else
   echo "Error has happened"
fi
echo '</body>'
echo '</html>'
 
exit 0
