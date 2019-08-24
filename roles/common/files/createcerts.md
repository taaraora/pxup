openssl genrsa  -out insecure_ca.key 2048 
openssl req -x509 -new -nodes -key insecure_ca.key -sha256 -days 9999 -out insecure_ca.crt
openssl genrsa -out node.key 2048
openssl req -new -key node.key -out node.csr -batch
