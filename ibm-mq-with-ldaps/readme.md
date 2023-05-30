runmqckm -keydb -create -db key.kdb -pw LenovoLenovo123 -type cms -stash
runmqckm -cert -add -db key.kdb -file CAPrivate.pem -pw LenovoLenovo123
runmqckm -cert -import -file MyMqCertificate.pfx -pw LenovoLenovo123 -type pkcs12 -target key.kdb -target_pw LenovoLenovo123 -target_type cms
runmqckm -cert -rename -db key.kdb -stashed -label 1 -new_label ibmwebpsheremqqmgr01


refresh security after each change in ldap
need to add attribute member to group in ldap

#need to change value of FINDGRP to member with lowercase



. /home/mqm/mq-ssl-setup.sh /home/mqm/CAPrivate.pem /home/mqm/MyMqCertificate.pfx yes QMgr01 mqadmins
. /opt/mqm/samp/bin/amqauthg.sh QMgr01 mqadmins

. /home/mqm/mq-auth-setup.sh QMgr01 mqadmins