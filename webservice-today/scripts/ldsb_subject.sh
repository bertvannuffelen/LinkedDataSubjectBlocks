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
  SUBJECT_URI=http://ENV_URI_DOMAIN/id/$SUBJECT 
  /scripts/subject_templates/query_store.sh /scripts/subject_templates/document.rq $SUBJECT_URI $LDSB
  if [ $? -eq 0 ] ; then
    case $format in
      nt) TARGET=$LDSB/subject.nt
        ;;
      ttl) rapper -i ntriples -o turtle subject.nt > subject.ttl
           TARGET=$LDSB/subject.ttl
	;;
      rdf) rapper -i ntriples -o rdfxml-abbrev subject.nt > subject.rdf
           TARGET=$LDSB/subject.rdf
	;;
      json) rapper -i ntriples -o json subject.nt > subject.json
           TARGET=$LDSB/subject.json
        ;;
      *) TARGET=$LDSB/subject.nt
	;;
    esac
      
    SUCCESS=0
  else
    SUCCESS=1
  fi

}

redirect() {

echo "Content-type: text/html"
#if [ $SUCCESS == 0 ] ; then
   echo "Status: 303 See Other"
   echo "Location: ENV_SERVERNAME$TARGET"
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
echo '</body>'
echo '</html>'
 
}

direct() {
    case $format in
      nt) 
   	 echo "Content-type: text/ntriples"
        ;;
      ttl) 
   	 echo "Content-type: text/turtle"
	;;
      rdf) 
   	 echo "Content-type: application/rdf+xml"
	;;
      json) 
   	 echo "Content-Type: application/json"
        ;;
      *) 
         echo "Content-type: text/html"
	;;
    esac

   echo "Status: 200 FOUND"
   echo ""
   cat $TARGET
}

mkdir -p $LDSB
get_subject
direct

exit 0


