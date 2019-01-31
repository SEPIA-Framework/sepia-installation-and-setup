#!/bin/bash
#
# make scripts executable
find . -name "*.sh" -exec chmod +x {} \;
chmod +x elasticsearch/bin/elasticsearch
#
# get name of main server JAR file (latest version)
cd sepia-assist-server
JAR_NAME=$(ls | grep "^sepia-assist.*jar" | tail -n 1)
#
# start interactive setup
echo ""
echo "Welcome to the SEPIA framework!"
echo ""
echo "This little script will help you with the configuration of your server."
echo "If you are here for the first time please take 5 minutes to read the (MIT) license agreement, especially the part about 'no-warranty' ^_^."
echo "You can find the license file in your download folder, in the SEPIA app or on one of the SEPIA pages, e.g.:"
echo "https://github.com/SEPIA-Framework/sepia-assist-server"
echo ""
echo "If you don't know what to do next read the guide at:"
echo "https://github.com/SEPIA-Framework/sepia-installation-and-setup#quick-start"
echo ""
echo "Typically for a new installation what you should do is (4) then (1) to setup the database and create the admin and assistant accounts."
echo "After that type the IP address or hostname of this machine into your SEPIA-Client login-screen and you are good to go :-)"
while true; do
	echo ""
	echo "What would you like to do next?"
	echo "1: Setup all components (except dynamic DNS). Note: requires step 4."
	echo "2: Define new admin and assistant passwords"
	echo "3: Setup dynamic DNS with DuckDNS"
	echo "4: Start Elasticsearch"
	echo "5: Set hostname of this machine to 'sepia-home' (works e.g. for Debian/Raspian Linux)"
	echo "6: Suggest cronjobs for server (open cronjobs manually with 'crontab -e' and copy/paste lines)"
	echo ""
	read -p "Enter a number plz (0 to exit): " option
	echo ""
	if [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		java -jar $JAR_NAME setup --my
		break
	elif [ $option = "2" ] 
	then
		java -jar $JAR_NAME setup accounts --my
		break
	elif [ $option = "3" ] 
	then
		java -jar $JAR_NAME setup duckdns --my
		echo "DONE. Please restart 'SEPIA assist server' to activate DuckDNS worker!"
		break
	elif [ $option = "4" ] 
	then	
		cd ..
		cd elasticsearch
		./run.sh
		./wait.sh
		cd ..
		cd sepia-assist-server
	elif [ $option = "5" ] 
	then
		sudo sh -c "echo 'sepia-home' > /etc/hostname"
		sudo sed -i -e 's|127\.0\.1\.1.*|127.0.1.1	sepia-home|g' /etc/hosts
		echo "Please reboot the system to use new hostname."
	elif [ $option = "6" ] 
	then
		echo "Cronjob suggestions:"
		echo ""
		echo '@reboot sleep 60 && ~/SEPIA/on-reboot.sh;'
		echo '30 4 1-31/2 * * ~/SEPIA/cronjob.sh;'
	else
		echo "Not an option, please try again."
	fi
done