#!/bin/bash
# NOTE: as cgi-script do not have any item written to STDOUT otherwise a 500 server error is being thrown

export PATH=$PATH:/usr/local/bundle/bin
export GEM_HOME=/usr/local/bundle

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
SERIALIZE="rdf serialize"

getcontext() {
   curl -s -o /tmp/context.map ENV_CONTEXTMAP
   declare -A contextmap
   source /tmp/context.map
   CONCEPT=`echo $SUBJECT | sed  "s /.* | " | sed "s/|//" `
}


serialize_opt() {

   rdf serialize --input-format ntriples --output-format $FORMAT -o $TARGET --context $CONTEXT $FILE

}
serialize() {

   rdf serialize --input-format ntriples --output-format $FORMAT -o $TARGET $FILE

}

get_subject_from_cache() {
    if [ -s $LDSB/subject.$format ] ; then
            TARGET=$LDSB/subject.$format
    else 
    if [ -s $LDSB/subject.nt ] ; then
        case $format in
           nt) TARGET=$LDSB/subject.nt
           ;;
           ttl) 
              FORMAT=turtle
              TARGET=$LDSB/subject.$format
              FILE=$LDSB/subject.nt
              serialize
           ;;
           rdf) 
              FORMAT=rdfxml
              TARGET=$LDSB/subject.$format
              FILE=$LDSB/subject.nt
              serialize
           ;;
           json) 
              FORMAT=rj
              TARGET=$LDSB/subject.$format
              FILE=$LDSB/subject.nt
              serialize
           ;;
           jsonld) 
              FORMAT=jsonld
              TARGET=$LDSB/$TARGETFILE.$format
              FILE=$LDSB/subject.nt
              getcontext
              CONTEXT=${contextmap[$CONCEPT]}
              if [ -z $CONTEXT ] ; then
                 echo "WARNING: no jsonld context found for $CONCEPT" 
                 serialize
              else 
                 serialize_opt
              fi
           ;;
           *) TARGET=$LDSB/subject.nt
           ;;
         esac
    fi
    fi
      
}

# derive the most recent version from a given URI
get_subject() {
  get_subject_from_cache
  if [ -z "$TARGET" ] ; then
  cd $LDSB
  SUBJECT_URI=ENV_URI_PREFIX/id/$SUBJECT 
  #/scripts/subject_templates/query_store.sh /scripts/subject_templates/direct_with_anonskolem_level1_and_concept.rq $SUBJECT_URI $LDSB
  /scripts/subject_templates/query_store.sh /scripts/subject_templates/ENV_QUERY  $SUBJECT_URI $LDSB
  if [ $? -eq 0 ] ; then
    if [ -s $LDSB/subject.nt ] ; then
    case $format in
      nt) TARGET=$LDSB/subject.nt
    ;;
      ttl) 
      FORMAT=turtle
      TARGET=$LDSB/subject.$format
      FILE=$LDSB/subject.nt
      serialize
   ;;
      rdf) 
      FORMAT=rdfxml
      TARGET=$LDSB/subject.$format
      FILE=$LDSB/subject.nt
      serialize
   ;;
      json) 
      FORMAT=rj
      TARGET=$LDSB/subject.$format
      FILE=$LDSB/subject.nt
      serialize
   ;;
      jsonld) 
      FORMAT=jsonld
      TARGET=$LDSB/$TARGETFILE.$format
      FILE=$LDSB/subject.nt
      getcontext
      CONTEXT=${contextmap[$CONCEPT]}
      if [ -z $CONTEXT ] ; then
         echo "WARNING: no jsonld context found for $CONCEPT" 
         serialize
      else 
         serialize_opt
      fi
        ;;
      *) TARGET=$LDSB/subject.nt
   ;;
    esac
      
     SUCCESS=0
    else
     SUCCESS=1
    fi
  else
    SUCCESS=1
  fi
  else
    SUCCESS=0
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
      jsonld) 
       echo "Content-Type: application/ld+json"
        ;;
      *) 
         echo "Content-type: text/html"
   ;;
    esac
   
   case  $SUCCESS in
     0) echo "Status: 200 FOUND"
        echo ""
        cat $TARGET
       ;;
     1) echo "Status: 404 NOT FOUND"
        echo ""
       ;;
     *) echo "Status: 404 NOT FOUND"
        echo ""
      ;;
   esac
}

mkdir -p $LDSB
get_subject
direct

exit 0


