### These two keystore files contain the SSL certificates with following common names

* pub.am.wso2.com
* store.am.wso2.com
* keymanager.am.wso2.com
* gateway.am.wso2.com
* mgt.gateway.am.wso2.com

Shown below is how to manually add certificates to keystore files shipped
in product pack by default.

How to generate SSL certs for above domains?
--------------------------------------------
* Login as root user.

* Create a directory /mnt/SSL/ and go inside.

Step 1
openssl genrsa -des3 -out publisher.key 1024
openssl genrsa -des3 -out apistore.key 1024
openssl genrsa -des3 -out keymanager.key 1024
openssl genrsa -des3 -out gateway.key 1024
openssl genrsa -des3 -out mgtgateway.key 1024

Step 2
openssl req -new -key publisher.key -out publisher.csr
openssl req -new -key apistore.key -out apistore.csr
openssl req -new -key keymanager.key -out keymanager.csr
openssl req -new -key gateway.key -out gateway.csr
openssl req -new -key mgtgateway.key -out mgtgateway.csr

Step 3
cp publisher.key publisher.key.org
cp apistore.key apistore.key.org
cp keymanager.key keymanager.key.org
cp gateway.key gateway.key.org
cp mgtgateway.key mgtgateway.key.org

Step 4
openssl rsa -in publisher.key.org -out publisher.key
openssl rsa -in apistore.key.org -out apistore.key
openssl rsa -in keymanager.key.org -out keymanager.key
openssl rsa -in gateway.key.org -out gateway.key
openssl rsa -in mgtgateway.key.org -out mgtgateway.key

Step 5
openssl x509 -req -days 365 -in publisher.csr -signkey publisher.key -out publisher.crt
openssl x509 -req -days 365 -in apistore.csr -signkey apistore.key -out apistore.crt
openssl x509 -req -days 365 -in gateway.csr -signkey gateway.key -out gateway.crt
openssl x509 -req -days 365 -in keymanager.csr -signkey keymanager.key -out keymanager.crt
openssl x509 -req -days 365 -in mgtgateway.csr -signkey mgtgateway.key -out mgtgateway.crt

How to add SSL certs to keystores?
----------------------------------
* Go to the location where .jks files are stored.

keytool -import -file /mnt/SSL/apistore.crt -alias apistore -keystore wso2carbon.jks -storepass wso2carbon
keytool -import -file /mnt/SSL/apistore.crt -alias apistore -keystore client-truststore.jks -storepass wso2carbon

keytool -import -file /mnt/SSL/publisher.crt -alias publisher -keystore wso2carbon.jks -storepass wso2carbon
keytool -import -file /mnt/SSL/publisher.crt -alias publisher -keystore client-truststore.jks -storepass wso2carbon

keytool -import -file /mnt/SSL/keymanager.crt -alias keymanager -keystore wso2carbon.jks -storepass wso2carbon
keytool -import -file /mnt/SSL/keymanager.crt -alias keymanager -keystore client-truststore.jks -storepass wso2carbon

keytool -import -file /mnt/SSL/gateway.crt -alias gateway -keystore wso2carbon.jks -storepass wso2carbon
keytool -import -file /mnt/SSL/gateway.crt -alias gateway -keystore client-truststore.jks -storepass wso2carbon

keytool -import -file /mnt/SSL/mgtgateway.crt -alias mgtgateway -keystore wso2carbon.jks -storepass wso2carbon
keytool -import -file /mnt/SSL/mgtgateway.crt -alias mgtgateway -keystore client-truststore.jks -storepass wso2carbon

