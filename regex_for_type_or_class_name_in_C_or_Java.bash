#!/bin/bash
file="$1"
sed -rn "s/(\s*\(\w+\) \w+)/&/p" "$file" >> ttttmp
sed -rn "s/^\s*(\w+) \w+\s?=\s?.*/\1/p" "$file" >> tttmp
cat tttmp | sort | uniq
