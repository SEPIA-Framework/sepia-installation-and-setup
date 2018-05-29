#!/bin/bash
echo ""
echo "Welcome to nginx setup for SEPIA"
echo "What would you like to do?"
echo "1: Setup nginx without SSL certificate (for testing)"
echo "2: Setup nginx with Let's Encrypt SSL certificate (requires successful SEPIA SSL setup)"
echo ""
read -p 'Enter a number plz (CTRL+C to exit): ' option
echo ""

# The SEPIA folder
SEPIA_FOLDER=~/SEPIA

if [ $option = "1" ]
then
	echo "Copying $SEPIA_FOLDER/nginx/sites-available/sepia-fw-http.conf to /etc/nginx/sites-enabled/ ..."
	cd $SEPIA_FOLDER/nginx/sites-available
	sudo cp sepia-fw-http.conf /etc/nginx/sites-enabled/sepia-fw-http.conf
	
	echo "Restarting nginx to load new config ..."
	sudo nginx -s reload
	
	echo ""
	ip=$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
	echo "You should be able to reach the server now at e.g.: http://$ip:9090"
	
	echo "DONE."
elif [ $option = "2" ] 
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
		echo "You should be able to reach the server now at e.g.: https://$DOMAIN:20726"
		echo "In your SEPIA client you can use the host name: $DOMAIN:20726/sepia"
		
		echo "DONE."
	else
		echo "Setup aborted. EXIT."
	fi
else
	echo "Not an option, please start again."
fi
