#!/bin/bash
# stat menu loop
while true; do
	echo ""
	echo "Welcome to nginx setup for SEPIA"
	echo "What would you like to do?"
	echo "1: Install nginx"
	echo "2: Setup nginx without SSL certificate (for testing or local networks)"
	echo "3: Setup nginx with Let's Encrypt SSL certificate (requires successful SEPIA SSL setup)"
	echo "4: Clean up and remove ALL old SEPIA configs from nginx (use this before switching from HTTP to HTTPS or vice versa)"
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
		sudo cp sepia-fw-http.conf /etc/nginx/sites-enabled/sepia-fw-http.conf
		
		echo "Restarting nginx to load new config ..."
		sudo nginx -s reload
		
		echo ""
		ip_adr=""
		if [ -x "$(command -v ifconfig)" ]; then
			ip_adr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
		elif [ -x "$(command -v ip)" ]; then
			ip_adr=$(ip a | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
		fi
		if [ -z "$ip_adr" ]; then
			ip_adr="[IP]"
		fi
		echo "------------------------"
		echo "DONE."
		echo "You should be able to reach the server at: http://$ip_adr:20726 or http://$(hostname).local:20726"
		echo "In your SEPIA client you can use the hostname: http://$ip_adr:20726/sepia or http://$(hostname).local:20726/sepia"
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
			sudo cp sepia-fw-https-$DOMAIN.conf /etc/nginx/sites-enabled/sepia-fw-https-$DOMAIN.conf
			
			echo "Modifying /etc/nginx/nginx.conf for SBC to use long domain names (server_names_hash_bucket_size 64) ..."
			sudo sed -i -e 's|# server_names_hash_bucket_size 64;|server_names_hash_bucket_size 64;|' /etc/nginx/nginx.conf
			
			echo "Restarting nginx to load new config ..."
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
		sudo rm -f /etc/nginx/sites-enabled/sepia-fw-*
	else
		echo "------------------------"
		echo "Not an option, please try again."
		echo "------------------------"
	fi
done
