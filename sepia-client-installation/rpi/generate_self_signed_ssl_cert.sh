#!/bin/bash
echo "Creating self-signed SSL certificate at $HOME/self-signed-ssl/ ..."
echo ""
echo "Host URL is: $(hostname -s).local (can be used as COMMON NAME for certificate)"
ip_adr=""
if [ -x "$(command -v ip)" ]; then
	ip_adr=$(ip a | grep -E 'eth0|wlan0' | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)
elif [ -x "$(command -v ifconfig)" ]; then
	ip_adr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)
fi
if [ -z "$ip_adr" ]; then
	ip_adr="[IP]"
fi
echo "IP should be: $ip_adr"
echo ""
echo "NOTE: The following tool may or may not ask you several questions. In this case use:"
echo "'$(hostname -s).local' as 'common name' (your hostname). All other fields can be left blank."
echo ""
read -p "Press any key to continue"
cd $HOME
mkdir -p self-signed-ssl
openssl req -nodes -new -x509 -days 3650 -newkey rsa:2048 -keyout self-signed-ssl/key.pem -out self-signed-ssl/certificate.pem \
  -subj "/CN=$(hostname -s).local" \
  -addext "subjectAltName=DNS:$(hostname -s).local,DNS:$ip_adr,DNS:localhost"
openssl x509 -text -in self-signed-ssl/certificate.pem -noout | grep "Subject:"
openssl x509 -text -in self-signed-ssl/certificate.pem -noout | grep "DNS:"
echo ""
echo "Certificates created. You can point your apps (server, proxy, etc.) to:"
echo "- $HOME/self-signed-ssl/certificate.pem"
echo "- $HOME/self-signed-ssl/key.pem"
echo "or copy the pem files wherever you need them."
