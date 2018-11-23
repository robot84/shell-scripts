#!/bin/bash
#Usage   ./myscript.sh -e conf -s /etc -l /usr/lib /etc/hosts 
VERSION="0.0.2"
BUG_EMAIL_ADDRESS="some@adress.com"
HOME_PAGE_ADDRESS="http://www.someweb.org/"
HELP_HOME_PAGE_ADDRESS="http://www.someweb.org/help/"

function parse_arguments() {
echo "\$#: $#"
if [ "$#" -lt 1 ]
then
	echo "$0: Mandatory argument ommited."
	echo "Try '$0 --help' for more information."
	exit
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -e|--extension)
    EXTENSION="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--searchpath)
    SEARCHPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--lib)
    LIBPATH="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
	-h|--help)
	echo "Usage:"
	echo "$0 [-e foo] [-s foo] [-l foo] <mandatory arg>"
#	echo "$0 [OPTION]... [FILE]..."
	echo "This command is doing this and this. General one line, short descr"
	echo
	echo -e "-l, --lib\t\tlibrary path"
	echo -e "-s, --search\t\tsearch path"
	echo -e "\t--help\t\tdisplay this help and exit"
	echo -e "\t--version\toutput version information and exit"
	echo
	echo "Examples:"
	echo -e "$0 -l /usr/lib -s /bin /etc/passwd\tfoo bar description"
	echo
	echo "Report bugs to $BUG_EMAIL_ADDRESS"
	echo "This soft hoem page: $HOME_PAGE_ADDRESS"
	echo "General help for this tools: $HELP_HOME_PAGE_ADDRESS"
	exit
	;;
	--version)
	# use package (tools) version or this script version?
	echo "app (GNU super-tool) 8.13"
	echo "Copyright (C) 2018 SO9ARC"
	echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
	echo "This is free software: you are free to change and redistribute it."
	echo "There is NO WARRANTY, to the extent permitted by law."
	exit
	;;
	-*)
	echo "$0: invalid option -- '$1'"
	echo "Try '$0 --help' for more information."
	exit
	;;
    *)    # unknown option
	echo "Adding to POSITIONAL: $1"
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
echo "Printing POSITIONAL:" ${POSITIONAL[@]}
echo "Restoring POSITIONAL to \$@"
set -- "${POSITIONAL[@]}" # restore positional parameters
echo "New \$#: $#. New \$@: " $@

echo DEFAULT         = "${DEFAULT}"
if [[ -n $1 ]]; then
   echo "Last argument: $1"
fi

echo "Returning from function..."
}

echo "Program arguments ($#). Program arguments are: $@"
echo "Call parse_arguments()"
parse_arguments $@
echo "Value of \$#: $#"
echo "Value of \$@: $@"
set -- "${POSITIONAL[@]}" # restore positional parameters
echo 'set -- "${POSITIONAL[@]}"'
echo "Value of \$#: $#"
echo "Value of \$@: $@"
