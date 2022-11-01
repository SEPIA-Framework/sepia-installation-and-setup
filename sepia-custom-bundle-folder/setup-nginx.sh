#!/bin/bash
set -e
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_FOLDER"
#
# get IP
ip_adr=""
net_interface=""
get_ip() {
	if [ -x "$(command -v route)" ]; then
		net_interface="$(route | grep '^default' | grep -o '[^ ]*$')"
	fi
	if [ -z "$net_interface" ]; then
		net_interface="eth0|wlan0"
	fi
	if [ -x "$(command -v ip)" ]; then
		ip_adr=$(ip a | grep -E "$net_interface" | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)
	elif [ -x "$(command -v ifconfig)" ]; then
		ip_adr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)
	fi
	if [ -z "$ip_adr" ]; then
		ip_adr="[IP]"
	fi
}
#
echo ""
echo "Welcome to NGINX setup for SEPIA."
echo ""
echo "To learn more about this setup and why SSL is required to allow for example microphone access in browser clients please visit:"
echo "https://github.com/SEPIA-Framework/sepia-docs/wiki/SSL-for-your-Server"
echo "If you are not sure what option to choose install NGINX (1) and try the self-signed SSL certificate (4)."
# stat menu loop
while true; do
	ip_adr=""
	net_interface=""
	echo ""
	echo "What would you like to do? (recommended: 1 and 4)"
	echo "1: Install NGINX"
	echo "2: Set up NGINX without SSL certificate (very easy setup, recommended for testing)"
	echo "3: Set up NGINX with Let's Encrypt SSL certificate (advanced setup for public servers, run AFTER dynamic DNS setup)"
	echo "4: Set up NGINX with self-signed SSL certificate and non-SSL fallback (easy setup, works on most clients, may show warning messages)"
	echo "5: Clean up and remove ALL old SEPIA server configs from NGINX (use this before switching from HTTP to HTTPS or vice versa)"
	echo ""
	read -p 'Enter a number plz (0 to exit): ' option
	echo ""

	if [ -z "$option" ] || [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		sudo apt update
		sudo apt-get install -y nginx
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "2" ]
	then
		echo "Copying $SEPIA_FOLDER/nginx/sites-available/sepia-fw-http.conf to /etc/nginx/sites-enabled/ ..."
		cd $SEPIA_FOLDER/nginx/sites-available
		cp sepia-fw-http.conf sepia-fw-http-latest.conf
		#sed -i -e 's|\[my-hostname-or-ip\]|'"${my_hostname}"'|g' sepia-fw-http-${my_hostname}.conf
		sed -i -e 's|\[my-sepia-path\]|'"$SEPIA_FOLDER"'|g' sepia-fw-http-latest.conf
		sudo cp sepia-fw-http-latest.conf /etc/nginx/sites-enabled/sepia-fw-http.conf
		
		echo "Restarting NGINX to load new config ..."
		sudo nginx -t
		sudo nginx -s reload
		
		echo ""
		get_ip
		echo "------------------------"
		echo "DONE."
		echo "You should be able to reach the server at: http://$ip_adr:20726 or http://$(hostname -s).local:20726"
		echo "In your SEPIA client you can use the hostname: http://$ip_adr:20726/sepia or http://$(hostname -s).local:20726/sepia"
		echo ""
		echo "Please note: if this is a virtual machine the external IP might be different and the hostname might not work at all!"
		echo "------------------------"
	elif [ $option = "3" ] 
	then
		# Get domain variable (DOMAIN) set via SEPIA DuckDNS setup
		cd $SEPIA_FOLDER/letsencrypt
		echo "Trying to load DOMAIN from $SEPIA_FOLDER/letsencrypt/duck-dns-settings.sh ..."
		source duck-dns-settings.sh
		if [ -n "$DOMAIN" ]
		then
			echo "Domain: $DOMAIN"
		else
			echo "No domain found in settings file. Please exit and run SEPIA setup or enter a domain manually now."
			read -p 'Domain, e.g. my.example.com (CTRL+C to exit): ' DOMAIN
		fi
		echo ""
		if [ -n "$DOMAIN" ]
		then
			cd $SEPIA_FOLDER/nginx/sites-available
			
			echo "Creating file sepia-fw-https-$DOMAIN.conf ..."
			cp sepia-fw-https.conf sepia-fw-https-$DOMAIN.conf
			sed -i -e 's|\[my-example-com\]|'"$DOMAIN"'|g' sepia-fw-https-$DOMAIN.conf
			sed -i -e 's|\[my-sepia-path\]|'"$SEPIA_FOLDER"'|g' sepia-fw-https-$DOMAIN.conf
			
			echo "Copying $SEPIA_FOLDER/nginx/sites-available/sepia-fw-https-$DOMAIN.conf to /etc/nginx/sites-enabled/ ..."
			sudo cp sepia-fw-https-$DOMAIN.conf /etc/nginx/sites-enabled/
			
			echo "Modifying /etc/nginx/nginx.conf for SBC to use long domain names (server_names_hash_bucket_size 64) ..."
			sudo sed -i -e 's|# server_names_hash_bucket_size 64;|server_names_hash_bucket_size 64;|' /etc/nginx/nginx.conf
			
			echo "Restarting NGINX to load new config ..."
			sudo nginx -t
			sudo nginx -s reload
			
			echo ""
			echo "------------------------"
			echo "DONE."
			echo "You should be able to reach the server now at e.g.: https://$DOMAIN:20726"
			echo "In your SEPIA client you can use the hostname: $DOMAIN:20726/sepia"
			echo "------------------------"
		else
			echo "------------------------"
			echo "Setup aborted. EXIT."
			echo "------------------------"
		fi
	elif [ $option = "4" ] 
	then
		cd $SEPIA_FOLDER/nginx
		
		echo "Creating self-signed SSL certificate ..."
		echo ""
		echo "Please confirm your [detected] hostname and IP address by pressing RETURN or enter new ones."
		read -p "Hostname [$(hostname -s).local]: " my_hostname
		my_hostname=${my_hostname:-$(hostname -s).local}
		get_ip
		read -p "IP address (interf.: $net_interface) [$ip_adr]: " my_ip_adr
		my_ip_adr=${my_ip_adr:-$ip_adr}
		echo ""
		echo "The 'openssl' tool will create new certificates now with $my_hostname as 'common name' and add"
		echo "$my_ip_adr to 'subject alternative names'. All other settings fields will be left blank."
		echo "After that new NGINX config files will be created and added to '/etc/nginx/sites-enabled/'."
		echo ""
		read -p "Press any key to continue"
		mkdir -p self-signed-ssl
		openssl req -nodes -new -x509 -days 3650 -newkey rsa:2048 -keyout self-signed-ssl/key.pem -out self-signed-ssl/certificate.pem \
			-subj "/CN=$my_hostname" \
			-addext "subjectAltName=DNS:$my_hostname,DNS:$my_ip_adr,DNS:localhost"
			#-addext "basicConstraints=CA:TRUE" \
			#-addext "keyUsage=digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment" \
			#-addext "extendedKeyUsage=serverAuth"
		# subj options: "/C=DE/ST=NRW/L=Essen/O=SEPIA OA Framework/OU=DEV/CN=yourdomain.com"
		openssl x509 -text -in self-signed-ssl/certificate.pem -noout | grep "Subject:"
		openssl x509 -text -in self-signed-ssl/certificate.pem -noout | grep "DNS:"
		
		echo "Copying $SEPIA_FOLDER/nginx/sites-available/sepia-fw-https-${my_hostname}.conf to /etc/nginx/sites-enabled/ ..."
		cd $SEPIA_FOLDER/nginx/sites-available
		cp sepia-fw-https-self-signed.conf sepia-fw-https-self-${my_hostname}.conf
		sed -i -e 's|\[my-hostname-or-ip\]|'"${my_hostname}"'|g' sepia-fw-https-self-${my_hostname}.conf
		sed -i -e 's|\[my-sepia-path\]|'"$SEPIA_FOLDER"'|g' sepia-fw-https-self-${my_hostname}.conf
		sudo cp sepia-fw-https-self-${my_hostname}.conf /etc/nginx/sites-enabled/
		
		echo "Restarting NGINX to load new config ..."
		sudo nginx -t
		sudo nginx -s reload
		
		echo ""
		echo "------------------------"
		echo "DONE."
		echo "You should be able to reach the server now, e.g. at:"
		echo "https://${my_hostname}:20726, https://$my_ip_adr:20726 or http://${my_hostname}:20727"
		echo ""
		echo "In your SEPIA client you can use the hostname:"
		echo "${my_hostname}:20726/sepia or https://$my_ip_adr:20726/sepia"
		echo ""
		echo "If you get problems because the client won't accept your self-signed certificate try:"
		echo "http://${my_hostname}:20727/sepia or http://$my_ip_adr:20727/sepia"
		echo ""
		echo "Please note: if this is a virtual machine the external IP might be different and the hostname might not work at all!"
		echo "------------------------"
	elif [ $option = "5" ] 
	then
		sudo rm -f /etc/nginx/sites-enabled/sepia-fw-*
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	else
		echo "------------------------"
		echo "Not an option, please try again."
		echo "------------------------"
	fi
	read -p "Press any key to continue (CTRL+C to exit)" anykey
done
