#!/bin/bash
cd database
for VAR in *.log
do
echo $VAR
CALLSIGN=`echo $VAR | awk -F  "." ' {print $1}'`
echo $CALLSIGN
done
cd -
