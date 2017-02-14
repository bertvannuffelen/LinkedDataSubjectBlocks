#!/bin/bash
# NOTE: as cgi-script do not have any item written to STDOUT otherwise a 500 server error is being thrown

#DATESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`
#caching per day
DATESTAMP=`date +%Y-%m-%d`

# assume the first argument is the subject URI
SUBJECT=$filepath
if [ "$SUBJECT" = "" ] ; then
  # this should lead to a 50x message
  exit 0
fi
SUBJECT_LDSB="file:///www/storage/$SUBJECT/LDSB.tgz"
LDSB="/www/tmp/$DATESTAMP/$SUBJECT/$version"

# assume the second argument is the version number
TARGETVERSION=$version
if [ "$TARGETVERSION" = "" ] ; then
  # this should lead to a 50x message
  exit 0
fi

get_nth_version() {
  tar -ztf LDSB.tgz >> /dev/null
  if [ $? -eq 0 ] ; then
    tar -zxf LDSB.tgz version
    source version
    if [ $VERSION = $TARGETVERSION ] ; then
        # do nothing as the return is the LDSB
    	# tar -zxf LDSB.tgz subject.nt
        SUCCESS=0
        TARGET="$LDSB/LDSB.tgz"
    else 
	if [ $VERSION < 0 || $VERSION < $TARGETVERSION ] ; then 
	 # echo "version not in the LDSB chain, returning a 404"
    	 # log this in log environment
         SUCCESS=1
        else
         mv LDSB_prev.tgz LDSB.tgz
	 get_nth_version
	fi

    fi
  else
    SUCCESS=2
    #echo "invalid LDSB, returning a 404"
    # log this in log environment
  fi

}

get_nth_version_init() {
  cd $LDSB
  curl -s $SUBJECT_LDSB -o LDSB.tgz 
  get_nth_version
}


get_nth_version_init

echo "Content-type: text/html"
case $SUCCESS in
   0) 
   	echo "Status: 303 See Other"
   	echo "Location: http://ENV_URI_DOMAIN$TARGET"
	;;
   1)
	echo "Status: 404 NOT FOUND"
	;;
   2) 
	echo "Status: 500 Internal Server Error "
	;;
esac
echo ""
echo '<html>'
echo '<head>'
echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
echo '<title>Redirect</title>'
echo '</head>'
echo '<body>'
echo '</body>'
echo '</html>'
 
exit 0
