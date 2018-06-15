#!/bin/bash
cd sepia-assist-server
JAR_NAME=$(ls | grep "^sepia-assist.*jar" | tail -n 1)
echo ""
echo "Welcome to the SEPIA framework!"
echo ""
echo "This little script will help you with the configuration of your server."
echo "If you are here for the first time please take 5 minutes to read the (MIT) license agreement, especially the part about 'no-warranty' ^_^."
echo "You can find the license file in your download folder, in the SEPIA app or on one of the SEPIA pages, e.g.:"
echo "https://github.com/SEPIA-Framework/sepia-assist-server"
echo ""
echo "What would you like to do next?"
echo "1: Setup all components (except dynamic DNS)"
echo "2: Define new admin and assistant passwords"
echo "3: Setup dynamic DNS with DuckDNS"
echo ""
read -p "Enter a number plz (CTRL+C to exit): " option
echo ""
if [ $option = "1" ]
then
	java -jar $JAR_NAME setup --my
elif [ $option = "2" ] 
then
	java -jar $JAR_NAME setup accounts --my
elif [ $option = "3" ] 
then
	java -jar $JAR_NAME setup duckdns --my
	echo "DONE. Please restart 'SEPIA assist server' to activate DuckDNS worker!"
else
	echo "Not an option, please start again."
fi
