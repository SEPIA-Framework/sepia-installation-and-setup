#!/bin/bash
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
echo "# Found Java: $JAVA_VERSION"
JAVA_8=$(echo $JAVA_VERSION | grep 1.8.)
REMOTE_ADR=$1
TRUSTSTORE=$2
TRUSTSTORE_ARGS=
KEYSTORE_PASS=$3
KEYTOOL=keytool

if [ -z "$TRUSTSTORE" ]
then
	# NOTE: in Java 11+ you can use '-cacerts' instead of path
	if [ -z "$JAVA_8" ]
	then
		TRUSTSTORE=cacerts
		TRUSTSTORE_ARGS=-cacerts
	elif [ -z "$JAVA_HOME" ]
	then
		echo "# ERROR: JAVA_HOME not found. Make sure it is defined or add path to truststore manually as 2nd argument!"
		exit 1
	else
		TRUSTSTORE=$JAVA_HOME/lib/security/cacerts
		TRUSTSTORE_ARGS="-keystore $TRUSTSTORE"
		if [ ! -f "$TRUSTSTORE" ]
		then
			echo "# ERROR: Truststore not found at: $TRUSTSTORE - Maybe you're using '/etc/ssl/certs/java/cacerts'?"
			exit 1
		fi
	fi
else
	if [ ! -f "$TRUSTSTORE" ]
	then
		echo "# ERROR: Truststore not found at: $TRUSTSTORE - Maybe you're using '/etc/ssl/certs/java/cacerts'?"
		exit 1
	else
		TRUSTSTORE_ARGS="-keystore $TRUSTSTORE"
	fi
fi
if [ -z "$3" ]
then
	KEYSTORE_PASS=changeit
fi
if [ -z "$REMOTE_ADR" ]
then
	echo "# ERROR: Please specify the remote address of the certificate to import, e.g. [IP]:[PORT]"
	exit 1
fi

echo "# Trying to import certificate at $REMOTE_ADR to truststore at $TRUSTSTORE"
rm -f $REMOTE_ADR.pem
rm -f keytool_stdout
rm -f err_out
set -e

if openssl s_client -connect $REMOTE_ADR 1>keytool_stdout 2>err_out </dev/null
then
	echo "# Checking certificate ..."
else
	cat keytool_stdout
	cat err_out
	exit 1
fi

if sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' <keytool_stdout > $REMOTE_ADR.pem
then
	echo "# Certificate temporarily stored at $REMOTE_ADR.pem. Importing ..."
else
	echo "# ERROR: Unable to extract the certificate from $REMOTE_ADR ($?)"
	cat err_out
	exit 1
fi

if $KEYTOOL -list -storepass ${KEYSTORE_PASS} -alias $REMOTE_ADR >/dev/null
then
	echo "# INFO: Key of $REMOTE_ADR already found in Keystore, skipping it."
else
	$KEYTOOL -importcert -trustcacerts -noprompt -storepass ${KEYSTORE_PASS} -alias $REMOTE_ADR -file $REMOTE_ADR.pem
fi

if $KEYTOOL -list -storepass ${KEYSTORE_PASS} -alias $REMOTE_ADR $TRUSTSTORE_ARGS >/dev/null
then
	echo "# INFO: Key of $REMOTE_ADR already found in Truststore, skipping it."
else
	sudo $KEYTOOL -importcert -trustcacerts -noprompt $TRUSTSTORE_ARGS -storepass ${KEYSTORE_PASS} -alias $REMOTE_ADR -file $REMOTE_ADR.pem
fi
echo "# Cleaning up ..."
rm -f $REMOTE_ADR.pem
rm -f keytool_stdout
rm -f err_out
echo "#"
echo "# DONE"
echo "#"
