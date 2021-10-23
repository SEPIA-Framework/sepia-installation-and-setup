#!/bin/bash
echo ""
echo "Welcome to NGINX setup for SEPIA."
echo ""
echo "To learn more about this setup and why SSL is required to allow for example microphone access in browser clients please visit:"
echo "https://github.com/SEPIA-Framework/sepia-docs/wiki/SSL-for-your-Server"
echo "If you are not sure what option to choose install NGINX (1) and try the self-signed SSL certificate (4)."
# stat menu loop
while true; do
	echo ""
	echo "What would you like to do?"
	echo "1: Install NGINX"
	echo "2: Set up NGINX without SSL certificate (very easy setup, recommended for testing)"
	echo "3: Set up NGINX with Let's Encrypt SSL certificate (advanced setup, requires successful SEPIA SSL setup)"
	echo "4: Set up NGINX with self-signed SSL certificate and non-SSL fallback (easy setup, works on most clients but shows warning message)"
	echo "5: Clean up and remove ALL old SEPIA configs from NGINX (use this before switching from HTTP to HTTPS or vice versa)"
	echo ""
	read -p 'Enter a number plz (0 to exit): ' option
	echo ""

	# The SEPIA folder
	SEPIA_FOLDER=~/SEPIA

	if [ -z "$option" ] || [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		sudo apt-get update
		sudo apt-get install -y nginx
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "2" ]
	then
		echo "Copying $SEPIA_FOLDER/nginx/sites-available/sepia-fw-http.conf to /etc/nginx/sites-enabled/ ..."
		cd $SEPIA_FOLDER/nginx/sites-available
		sudo cp sepia-fw-http.conf /etc/nginx/sites-enabled/
		
		echo "Restarting NGINX to load new config ..."
		sudo nginx -t
		sudo nginx -s reload
		
		echo ""
		ip_adr=""
		if [ -x "$(command -v ip)" ]; then
			# old: ifconfig
			ip_adr=$(ip a | grep -E 'eth0|wlan0' | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)
		fi
		if [ -z "$ip_adr" ]; then
			ip_adr="[IP]"
		fi
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
		echo "NOTE: The following tool will ask you several questions."
		echo "Use '$(hostname -s).local' as 'common name' (your hostname). All other fields can be left blank."
		echo ""
		read -p "Press any key to continue"
		mkdir -p self-signed-ssl
		openssl req -nodes -new -x509 -days 365 -keyout self-signed-ssl/key.pem -out self-signed-ssl/certificate.pem
		
		echo "Copying $SEPIA_FOLDER/nginx/sites-available/sepia-fw-https-$(hostname -s).conf to /etc/nginx/sites-enabled/ ..."
		cd $SEPIA_FOLDER/nginx/sites-available
		cp sepia-fw-https-self-signed.conf sepia-fw-https-self-$(hostname -s).conf
		sed -i -e 's|\[my-hostname-or-ip\]|'"$(hostname -s).local"'|g' sepia-fw-https-self-$(hostname -s).conf
		sed -i -e 's|\[my-sepia-path\]|'"$SEPIA_FOLDER"'|g' sepia-fw-https-self-$(hostname -s).conf
		sudo cp sepia-fw-https-self-$(hostname -s).conf /etc/nginx/sites-enabled/
		
		echo "Restarting NGINX to load new config ..."
		sudo nginx -t
		sudo nginx -s reload
		
		echo ""
		echo "------------------------"
		echo "DONE."
		echo "You should be able to reach the server now, e.g. at:"
		echo "https://$(hostname -s).local:20726, https://$ip_adr:20726 or http://$(hostname -s).local:20727"
		echo ""
		echo "In your SEPIA client you can use the hostname:"
		echo "$(hostname -s).local:20726/sepia or https://$ip_adr:20726/sepia"
		echo ""
		echo "If you get problems because the client won't accept your self-signed certificate try:"
		echo "http://$(hostname -s).local:20727/sepia or http://$ip_adr:20727/sepia"
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
done
