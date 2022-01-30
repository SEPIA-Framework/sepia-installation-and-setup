#!/bin/bash
set -e
if [ "$#" -ne 2 ]; then
	echo "Usage: bash import_SSL_cert_from_page.sh [host:port] [target-name]"
	echo "Example: bash import_SSL_cert_from_page.sh \"sepia-home.local:20726\" sepia-home"
	exit 1
fi
echo "Downloading cert. from $1 ..."
mkdir -p downloads
rm -f "downloads/$2.crt"
echo -n | openssl s_client -connect $1 | openssl x509 > "downloads/$2.crt"
echo "Found this certificate:"
openssl x509 -text -in "downloads/$2.crt" -noout | grep "Subject:"
openssl x509 -text -in "downloads/$2.crt" -noout | grep "DNS:"
read -p "Press any key to import to '/usr/local/share/ca-certificates/' (CTRL+C to exit)" anykey
sudo cp "downloads/$2.crt" "/usr/local/share/ca-certificates/$2.crt"
echo "Updating ca-certificates ..."
sudo update-ca-certificates
echo "DONE"
