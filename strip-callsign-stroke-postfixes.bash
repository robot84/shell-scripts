#!/bin/bash
# v 0.0.2
# Strip callsign from any postfixes, like /M /P /9 /AM /MM etc
# stripped callsign if printed on stdout

if [ "$#" -ne 1 ]
	then
	echo "Usage:"
	echo "$0 <callsign>"
	exit 1
fi


CALLSIGN="$1"
if [[ "$CALLSIGN" =~ [A-Za-z0-9]*/[A-Za-z0-9][A-Za-z0-9]* ]]
then
STRIPPED=`echo $CALLSIGN | awk -F/ '{print $1}'`
echo $STRIPPED | tr '[[:lower:]]' '[[:upper:]]'
else
echo "$0 Error: |$CALLSIGN| don't match RegEx"
exit 2
fi

