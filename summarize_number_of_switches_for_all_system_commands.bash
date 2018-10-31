#!/bin/bash
#
# This script calculates how many switches have got in summary
# all applications installed on a system.
# For example:
# bash [-abder]
# command bash has 5 switches. This script summarise them all
# for all apps available on system.
#
# Version 0.2.0 (C) 2018 Robert Zabkiewicz
#
APPS_COUNT=`echo $PATH | tr ":" " " | xargs ls -1 | wc -l`
BLACK_LIST_FILE=/tmp/.black_list_$(basename ${0})
TMP_FILE1=/tmp/$(mktemp tmp.$(basename ${0})XXXXXXXXXX)
TMP_FILE2=/tmp/$(mktemp tmp.$(basename ${0})XXXXXXXXXX)
BLACK_LIST_COUNT=0
SWITCHES_COUNT=0
__FILE_MOD_10_COUNTER=0
__TWISTER__COUNTER=0


##### Functions ######


function print_name_of_every_10th_parsed_file {
(( __FILE_MOD_10_COUNTER ++ ))
if [ $__FILE_MOD_10_COUNTER -ge 10 ]
then
(( __TWISTER__COUNTER ++ ))
echo -n -e "\r\033[K"
case $__TWISTER__COUNTER in
[12])
echo -n "-"
;;
[34])
echo -n "\\"
;;
[56])
echo -n "|"
;;
[7])
echo -n "/"
;;
8)
echo -n "/"
(( __TWISTER__COUNTER = 0 ))
;;
esac
echo -n  " $1 : $2"
(( __FILE_MOD_10_COUNTER = 0 ))
fi
}


function f_ctrl_c() {
		cat $TMP_FILE1 >> $BLACK_LIST_FILE
		echo
		echo "**** CTRL-C Trapped ****"
		echo "**** Added '$APP_NAME' to black_list file."
		echo "**** Exiting. Run me once again."
		rm $TMP_FILE1
		rm $TMP_FILE2
		exit 1
		}


##### End of Functions ######


if [ ! -f $BLACK_LIST_FILE ]
then
cat > $BLACK_LIST_FILE << THIS_IS_THE_END_OF_BLACK_LIST_INITIAL_FILE
^a2p$
^c2ph$
^cpan$
^debconf-apt-progress$
^instmodsh$
^line$
^nslookup$
^perlbug$
^perlthanks$
^procmail$
^pstruct$
^rstartd$
^servertool$
^splain$
^ssh-keygen$
^startx$
^vimtutor$
^xinit$
THIS_IS_THE_END_OF_BLACK_LIST_INITIAL_FILE

fi

BLACK_LIST_COUNT=`cat $BLACK_LIST_FILE | wc -l`
(( APPS_COUNT = $APPS_COUNT - $BLACK_LIST_COUNT ))
echo $PATH | tr ":" " " | xargs ls -1 | grep -v "^$" | grep -v ":" > $TMP_FILE2

trap f_ctrl_c INT

cd $(mktemp -d)
for x in $(seq 1 1 $APPS_COUNT)
do
APP_NAME=`sed -n "${x}p" $TMP_FILE2`
echo   "^$APP_NAME$" > $TMP_FILE1
ARGS=`echo $APP_NAME | grep -f ${BLACK_LIST_FILE} || ${APP_NAME} --help 2>&1 | grep -P '^\s*\-' | wc -l`
print_name_of_every_10th_parsed_file $APP_NAME $ARGS
(( SWITCHES_COUNT = $SWITCHES_COUNT + $ARGS ))
done

# clean-up
rm $TMP_FILE1
rm $TMP_FILE2
rm -r *
rmdir  $(pwd)
cd - >> /dev/null
# print result
echo  -e "\r\033[K"
echo "Found $SWITCHES_COUNT switches in $APPS_COUNT binaries and scripts."
