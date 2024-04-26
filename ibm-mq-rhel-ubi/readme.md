python3 -m http.server 9000
ip addr show


/usr/sbin/sshd

cat /etc/ssh/sshd_config
Match Host "*" User "ivansla"
    AllowGroups ivansla
    AllowUsers ivansla
    AuthenticationMethods publickey password
    AuthorizedKeysFile /home/ivansla/.ssh/authorized_keys


ssh-copy-id -i ~/.ssh/id_rsa.pub ivansla@172.18.0.2





# Generate CA
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.pem -subj "/CN=ca"

# Generate MQ Client
openssl genrsa -out mqclient.key 2048
openssl req -new -key mqclient.key -out mqclient.csr -subj "/CN=mqclient"
openssl x509 -req -in mqclient.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out mqclient.crt -days 3650 -sha256
cat mqclient.crt ca.pem > mqclient-full-chain.crt
openssl pkcs12 -export -out mqclient.pfx -inkey mqclient.key -in mqclient-full-chain.crt -passout pass:passw0rd -name mqclient

# Generate MQ Client
openssl genrsa -out mqserver.key 2048
openssl req -new -key mqserver.key -out mqserver.csr -subj "/CN=mqserver"
openssl x509 -req -in mqserver.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out mqserver.crt -days 3650 -sha256
cat mqserver.crt ca.pem > mqserver-full-chain.crt
openssl pkcs12 -export -out mqserver.pfx -inkey mqserver.key -in mqserver-full-chain.crt -passout pass:passw0rd -name mqserver

# Generate key.kdb
rm -f /home/mqm/qmgrs/data/QMgr01/ssl/key.*
runmqckm -keydb -create -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -pw passw0rd -type cms -stash
runmqckm -cert -import -file /home/mqm/certs/mqserver.pfx -pw passw0rd -type pkcs12 -target /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -target_stashed -target_type cms
runmqckm -cert -rename -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -stashed -label mqserver -new_label ibmwebspheremqqmgr01
runmqckm -cert -list -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -type cms -stashed
runmqckm -cert -details -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -type cms -stashed -label ibmwebspheremqqmgr01

# Populate key.kdb with a full certificate chain
runmqckm -cert -add -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -file /home/mqm/certs/ca-company.pem -stashed
runmqckm -cert -add -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -file /home/mqm/certs/ca-accounting.crt -stashed
runmqckm -cert -add -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -file /home/mqm/certs/ca-human-resources.crt -stashed

# Generate keystore.jks
rm -f /home/mqm/certs/keystore.jks
runmqckm -keydb -create -db /home/mqm/certs/keystore.jks -pw passw0rd -type jks
runmqckm -cert -import -file /home/mqm/certs/mqclient.pfx -pw passw0rd -type pkcs12 -target /home/mqm/certs/keystore.jks -target_pw passw0rd -target_type jks
runmqckm -cert -list -db /home/mqm/certs/keystore.jks -pw passw0rd
runmqckm -cert -details -db /home/mqm/certs/keystore.jks -pw passw0rd -label mqclient

# Generate truststore.jks
rm -f /home/mqm/certs/truststore.jks
runmqckm -keydb -create -db /home/mqm/certs/truststore.jks -pw passw0rd -type jks
runmqckm -cert -add -db /home/mqm/certs/truststore.jks -file /home/mqm/certs/mqserver.crt -pw passw0rd
runmqckm -cert -list -db /home/mqm/certs/truststore.jks -pw passw0rd
runmqckm -cert -details -db /home/mqm/certs/truststore.jks -pw passw0rd -label cn=mqserver