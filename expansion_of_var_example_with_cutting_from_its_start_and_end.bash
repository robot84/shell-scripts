#!/bin/bash
for user in ../SO9ARC/database/*.log
do
echo $user
user=${user%.log}
echo $user
user=${user##*/}
echo $user
sleep 1


done
