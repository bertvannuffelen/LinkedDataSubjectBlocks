#!/bin/sh

/config/bin/replace-env.sh /usr/local/apache2/conf/extra/httpd-vhosts.conf
/config/bin/replace-env.sh /scripts/subject_templates/query_store.sh
/config/bin/replace-env.sh /scripts/ldsb_subject.sh
/config/bin/replace-env.sh /scripts/error.sh

httpd-foreground
