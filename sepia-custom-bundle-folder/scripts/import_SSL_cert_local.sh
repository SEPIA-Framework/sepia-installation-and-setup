#!/bin/bash
set -e
if [ "$#" -ne 2 ]; then
	echo "Usage: bash import_SSL_cert_local.sh [my-certificate.pem] [target-name]"
	echo "Example: bash import_SSL_cert_local.sh \"$HOME/SEPIA/nginx/self-signed-ssl/certificate.pem\" sepia-home"
	exit 1
fi
echo "Copying $1 to /usr/local/share/ca-certificates/$2.crt ..."
sudo cp "$1" "/usr/local/share/ca-certificates/$2".crt
# better?
# sudo openssl x509 -outform der -in "$1" -out "/usr/local/share/ca-certificates/$2.crt"
echo "Updating ca-certificates ..."
sudo update-ca-certificates
echo "DONE"
