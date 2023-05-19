docker build --tag=your-docker-username/your-docker-repository:apache-ds .
docker run -dt --name apache-ds your-docker-username/your-docker-repository:apache-ds
docker network create my-network
docker network connect my-network apache-ds
docker network inspect my-network
docker exec -ti apache-ds bash
service --status-all
service apacheds-2.0.0.AM26-default start

openssl genrsa -des3 -out CAPrivate.key 2048
openssl req -x509 -new -nodes -key CAPrivate.key -sha256 -days 3650 -out CAPrivate.pem -subj "/CN=my-ca"
openssl genrsa -out LdapPrivate.key 2048
openssl req -new -key LdapPrivate.key -out LdapRequest.csr -subj "/CN=my-apache-ds"
openssl x509 -req -in LdapRequest.csr -CA CAPrivate.pem -CAkey CAPrivate.key -CAcreateserial -out LdapCertificate.crt -days 3650 -sha256
openssl pkcs12 -export -out LdapCertificate.pfx -inkey LdapPrivate.key -in LdapCertificate.crt
keytool -importkeystore -srckeystore LdapCertificate.pfx -destkeystore keystore.jks -srcstoretype pkcs12

docker cp keystore.jks apache-ds:/var/lib/apacheds-2.0.0.AM26/default/conf
service apacheds-2.0.0.AM26-default restart


