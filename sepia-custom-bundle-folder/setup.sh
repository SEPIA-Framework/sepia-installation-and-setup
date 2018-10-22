#!/bin/bash
#
# get name of main server JAR file (latest version)
cd sepia-assist-server
JAR_NAME=$(ls | grep "^sepia-assist.*jar" | tail -n 1)
#
# make scripts executable
find . -name "*sh" -exec chmod +x {} \;
chmod +x elasticsearch/bin/elasticsearch
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
while true; do
	echo ""
	echo "What would you like to do next?"
	echo "1: Setup all components (except dynamic DNS). Note: requires step 4."
	echo "2: Define new admin and assistant passwords"
	echo "3: Setup dynamic DNS with DuckDNS"
	echo "4: Start Elasticsearch"
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
	else
		echo "Not an option, please try again."
	fi
done