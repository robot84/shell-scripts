#!/bin/bash
while grep "sunday" file.txt > /dev/null;
do
    sleep 1
    echo "working..."
done
