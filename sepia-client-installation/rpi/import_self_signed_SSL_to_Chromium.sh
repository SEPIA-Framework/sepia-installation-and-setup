#!/bin/bash
set -e
if [ "$#" -ne 2 ]; then
	echo "Usage: bash import_self_signed_SSL_to_Chromium.sh [host:port] [cert-name]"
	echo "Example: bash import_self_signed_SSL_to_Chromium.sh \"sepia-home.local:20726\" sepia-home"
	exit 1
fi
echo "Importing '/usr/local/share/ca-certificates/$2.crt' as '$1' into NSSDB"
certutil -d "sql:$HOME/.pki/nssdb" -A -t "C,," -n "$1" -i "/usr/local/share/ca-certificates/$2.crt"
echo "DONE"
