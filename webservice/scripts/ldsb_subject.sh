#!/bin/bash
# NOTE: as cgi-script do not have any item written to STDOUT otherwise a 500 server error is being thrown

#set -x
#E=`env`

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
get_subject() {
  cd $LDSB
  curl -s $SUBJECT_LDSB -o LDSB.tgz 
  tar -ztf LDSB.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    tar -zxf LDSB.tgz subject.nt
    case $format in
      nt) TARGET=$LDSB/subject.nt
        ;;
      ttl) rapper -i ntriples -o turtle subject.nt > subject.ttl
           TARGET=$LDSB/subject.ttl
	;;
      ttl) rapper -i ntriples -o rdfxml subject.nt > subject.rdf
           TARGET=$LDSB/subject.rdf
	;;
      *) TARGET=$LDSB/subject.nt
	;;
    esac
      
    SUCCESS=0
  else
    SUCCESS=1
  fi

}

mkdir -p $LDSB
get_subject
#echo $TARGET >> /var/log/apache2/ldsb_error.log

echo "Content-type: text/html"
#if [ $SUCCESS == 0 ] ; then
   echo "Status: 303 See Other"
   echo "Location: http://data.vlaanderen.be$TARGET"
#else
#   echo "Status: 404 Condition Intercepted"
#fi
echo ""
echo '<html>'
echo '<head>'
echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
echo '<title>Redirect</title>'
echo '</head>'
echo '<body>'
#if [ $SUCCESS == 0 ] ; then
#   echo "Redirect to cached location"
#else
#   echo "Error has happened"
#fi
#echo "------------------------\n"
echo '</body>'
echo '</html>'
 
exit 0
