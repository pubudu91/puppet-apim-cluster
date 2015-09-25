## Following domain names are used

pub.am.wso2.com  
store.am.wso2.com  
keymanager.am.wso2.com  
gateway.am.wso2.com  

## Create SSL certificates

sudo openssl genrsa -des3 -out publisher.key 1024  
sudo openssl genrsa -des3 -out apistore.key 1024  
sudo openssl genrsa -des3 -out keymanager.key 1024  
sudo openssl genrsa -des3 -out gateway.key 1024  

sudo openssl req -new -key publisher.key -out publisher.csr  
sudo openssl req -new -key apistore.key -out apistore.csr  
sudo openssl req -new -key keymanager.key -out keymanager.csr  
sudo openssl req -new -key gateway.key -out gateway.csr  

sudo cp publisher.key publisher.key.org  
sudo cp apistore.key apistore.key.org  
cp keymanager.key keymanager.key.org  
cp gateway.key gateway.key.org  

openssl rsa -in publisher.key.org -out publisher.key  
openssl rsa -in apistore.key.org -out apistore.key  
openssl rsa -in keymanager.key.org -out keymanager.key  
openssl rsa -in gateway.key.org -out gateway.key  

openssl x509 -req -days 365 -in publisher.csr -signkey publisher.key -out publisher.crt  
openssl x509 -req -days 365 -in apistore.csr -signkey apistore.key -out apistore.crt  
openssl x509 -req -days 365 -in gateway.csr -signkey gateway.key -out gateway.crt  
openssl x509 -req -days 365 -in keymanager.csr -signkey keymanager.key -out keymanager.crt  

## Adding all 4 certificates to the AM 1.9.0 pack keystores  

keytool -import -file /mnt/SSL/apistore.crt -alias apistore -keystore wso2carbon.jks -storepass wso2carbon  
keytool -import -file /mnt/SSL/apistore.crt -alias apistore -keystore client-truststore.jks -storepass wso2carbon  

keytool -import -file /mnt/SSL/publisher.crt -alias publisher -keystore wso2carbon.jks -storepass wso2carbon  
keytool -import -file /mnt/SSL/publisher.crt -alias publisher -keystore client-truststore.jks -storepass wso2carbon  

keytool -import -file /mnt/SSL/keymanager.crt -alias keymanager -keystore wso2carbon.jks -storepass wso2carbon  
keytool -import -file /mnt/SSL/keymanager.crt -alias keymanager -keystore client-truststore.jks -storepass wso2carbon  

keytool -import -file /mnt/SSL/gateway.crt -alias gateway -keystore wso2carbon.jks -storepass wso2carbon  
keytool -import -file /mnt/SSL/gateway.crt -alias gateway -keystore client-truststore.jks -storepass wso2carbon  

