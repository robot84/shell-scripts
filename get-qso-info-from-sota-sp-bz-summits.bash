#!/bin/bash
# Robert Zabkiewicz (c) 2018
# Before use, generate input files by command:
# wget -nc -rl1 https://www.sota.org.uk/Association/SP/BZ
#

VERSION=0.0.2

# Revision History:
# 0.0.1 Initial version
# 0.0.2 testing if directory structure exists
#
#

if [ -d summit ] && [ -d summit/SP ] && [ -e summit/SP/BZ-001 ]
then

touch ALL_BZ.txt
for VAR in summit/SP/BZ-0*
do
# echo $VAR >> ALL_BZ.txt
cat $VAR | html2text | grep "\*\*\*\*\*" >> ALL_BZ.txt
cat $VAR | html2text | grep -A 12 "on these bands" >> ALL_BZ.txt
done

sed -n '/^2m\|70cm\|BZ-0/p' ALL_BZ.txt > UHF.txt
#sed -n '/^2m\|BZ-0/p' ALL_BZ.txt > UHF.txt

# Merging two lines into one:
# sed 'N;s/\n/ /' UHF2m.txt
# awk 'NR%2{printf "%s ",$0;next;}1' UHF2m.txt

else
  echo
  echo 'Directory structure doesn`t exist. Create it typing:'
  echo 'wget -nc -rl1 https://www.sota.org.uk/Association/SP/BZ'
fi
