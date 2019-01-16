#!/bin/sh

/config/bin/replace-env.sh /usr/local/apache2/conf/extra/httpd-vhosts.conf
/config/bin/replace-env.sh /scripts/subject_templates/query_store.sh
/config/bin/replace-env.sh /scripts/subject_templates/direct_with_anon_level1_and_concept.rq
/config/bin/replace-env.sh /scripts/subject_templates/direct_with_anonskolem_level1_and_concept.rq
/config/bin/replace-env.sh /scripts/ldsb_subject.sh
/config/bin/replace-env.sh /scripts/error.sh

if [ ! $ENV_LOGLOCAL ] ; then
    ln -sf /dev/stderr /logs/error_log
    ln -sf /dev/stdout /logs/access_log
fi

httpd -DFOREGROUND
