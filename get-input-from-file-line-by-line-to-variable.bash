#!/bin/bash
while read CALLSIGN;
do
cp $CALLSIGN temp/
done <tmp
