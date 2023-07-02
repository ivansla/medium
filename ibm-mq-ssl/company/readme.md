# Generate CA Company
openssl genrsa -out ca-company.key 2048
openssl req -x509 -new -nodes -key ca-company.key -sha256 -days 3650 -out ca-company.pem -subj "/CN=ca-company"

# Generate CA Accounting
openssl genrsa -out ca-accounting.key 2048
openssl req -new -key ca-accounting.key -out ca-accounting.csr -subj "/CN=ca-accounting"
openssl x509 -req -in ca-accounting.csr -CA ca-company.pem -CAkey ca-company.key -CAcreateserial -out ca-accounting.crt -days 3650 -sha256

# Generate User Accounting
openssl genrsa -out user-accounting.key 2048
openssl req -new -key user-accounting.key -out user-accounting.csr -subj "/CN=user-accounting"
openssl x509 -req -in user-accounting.csr -CA ca-accounting.crt -CAkey ca-accounting.key -CAcreateserial -out user-accounting.crt -days 3650 -sha256
cat user-accounting.crt ca-accounting.crt ca-company.pem > user-accounting-full.crt
openssl pkcs12 -export -out user-accounting.pfx -inkey user-accounting.key -in user-accounting.crt -passout pass:passw0rd -name user-accounting

# Generate CA Human Resources
openssl genrsa -out ca-human-resources.key 2048
openssl req -new -key ca-human-resources.key -out ca-human-resources.csr -subj "/CN=ca-human-resources"
openssl x509 -req -in ca-human-resources.csr -CA ca-company.pem -CAkey ca-company.key -CAcreateserial -out ca-human-resources.crt -days 3650 -sha256

# Generate User Human Resources
openssl genrsa -out user-human-resources.key 2048
openssl req -new -key user-human-resources.key -out user-human-resources.csr -subj "/CN=user-human-resources"
openssl x509 -req -in user-human-resources.csr -CA ca-human-resources.crt -CAkey ca-human-resources.key -CAcreateserial -out user-human-resources.crt -days 3650 -sha256
cat user-human-resources.crt ca-human-resources.crt ca-company.pem > user-human-resources-full.crt
openssl pkcs12 -export -out user-human-resources.pfx -inkey user-human-resources.key -in user-human-resources.crt -passout pass:passw0rd

# Generate CA Third Party Company
openssl genrsa -out ca-third-party-company.key 2048
openssl req -x509 -new -nodes -key ca-third-party-company.key -sha256 -days 3650 -out ca-third-party-company.pem -subj "/CN=ca-third-party-company"

# Generate User Third Party Company
openssl genrsa -out user-third-party-company.key 2048
openssl req -new -key user-third-party-company.key -out user-third-party-company.csr -subj "/CN=user-third-party-company"
openssl x509 -req -in user-third-party-company.csr -CA ca-third-party-company.pem -CAkey ca-third-party-company.key -CAcreateserial -out user-third-party-company.crt -days 3650 -sha256
openssl pkcs12 -export -out user-third-party-company.pfx -inkey user-third-party-company.key -in user-third-party-company.crt -passout pass:passw0rd

# Generate key.kdb
rm -f /home/mqm/qmgrs/data/QMgr01/ssl/key.*
runmqckm -keydb -create -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -pw passw0rd -type cms -stash
runmqckm -cert -import -file /home/mqm/ssl/user-accounting.pfx -pw passw0rd -type pkcs12 -target /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -target_stashed -target_type cms
runmqckm -cert -rename -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -stashed -label user-accounting -new_label ibmwebspheremqqmgr01
runmqckm -cert -list -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -type cms -stashed
runmqckm -cert -details -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -type cms -stashed -label ibmwebspheremqqmgr01

# Populate key.kdb with a full certificate chain
runmqckm -cert -add -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -file /home/mqm/ssl/ca-company.pem -stashed
runmqckm -cert -add -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -file /home/mqm/ssl/ca-accounting.crt -stashed
runmqckm -cert -add -db /home/mqm/qmgrs/data/QMgr01/ssl/key.kdb -file /home/mqm/ssl/ca-human-resources.crt -stashed

# Generate keystore.jks
rm -f /home/mqm/ssl/keystore.jks
runmqckm -keydb -create -db /home/mqm/ssl/keystore.jks -pw passw0rd -type jks
runmqckm -cert -import -file /home/mqm/ssl/user-human-resources.pfx -pw passw0rd -type pkcs12 -target /home/mqm/ssl/keystore.jks -target_pw passw0rd -target_type jks
runmqckm -cert -list -db /home/mqm/ssl/keystore.jks -pw passw0rd
runmqckm -cert -details -db /home/mqm/ssl/keystore.jks -pw passw0rd -label user-human-resources

# Generate truststore.jks
rm -f /home/mqm/ssl/truststore.jks
runmqckm -keydb -create -db /home/mqm/ssl/truststore.jks -pw passw0rd -type jks
runmqckm -cert -add -db /home/mqm/ssl/truststore.jks -file /home/mqm/ssl/user-accounting.crt -pw passw0rd
runmqckm -cert -list -db /home/mqm/ssl/truststore.jks -pw passw0rd
runmqckm -cert -details -db /home/mqm/ssl/truststore.jks -pw passw0rd -label cn=user-accounting