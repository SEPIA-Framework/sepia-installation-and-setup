#!/bin/bash
cd sepia-assist-server
JAR_NAME=$(ls | grep "^sepia-assist.*jar" | tail -n 1)
echo ""
echo "Welcome to the SEPIA setup"
echo "What would you like to do?"
echo "1: Setup all (except dynamic DNS)"
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
