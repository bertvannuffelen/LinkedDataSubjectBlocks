#!/bin/sh

#/config/bin/replace-env.sh /usr/local/apache2/conf/extra/httpd-vhosts.conf
/config/bin/replace-env.sh /etc/apache2/sites-available/ldsb.conf
/config/bin/replace-env.sh /scripts/subject_templates/query_store.sh
/config/bin/replace-env.sh /scripts/subject_templates/direct_with_anon_level1_and_concept.rq
/config/bin/replace-env.sh /scripts/subject_templates/direct_with_anonskolem_level1_and_concept.rq
/config/bin/replace-env.sh /scripts/ldsb_subject.sh
/config/bin/replace-env.sh /scripts/error.sh

case $ENV_LOGLOCAL in
   all) 
       echo "logs are propagated external to Docker container. Other options are all|access|error|none \n"
      ln -sf /proc/1/fd/1 /logs/error_log
      ln -sf /proc/1/fd/1 /logs/access_log
   ;;
   access) 
       echo "Access logs are propagated external to Docker container. Error logs are stored in the Docker images at /logs. Other options are all|access|error|none \n"
      ln -sf /proc/1/fd/1 /logs/access_log
   ;;
   error) 
       echo "Error logs are propagated external to Docker container. Access logs are stored in the Docker images at /logs. Other options are all|access|error|none \n"
      ln -sf /proc/1/fd/1 /logs/error_log
   ;;
   none) 
       echo "logs are stored in the Docker images at /logs. Other options are all|access|error|none \n"
   ;;
   *)
       echo "logs are stored in the Docker images at /logs. Other options are all|access|error|none \n"
esac

#httpd -DFOREGROUND
#touch /tmp/file
#tail -f /tmp/file

apache2ctl start
#tail -f /logs/access_log
#tail -f /dev/stdout
while true; do sleep 1; done
#tail -f /var/log/apache2/access.log


