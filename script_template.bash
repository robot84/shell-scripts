#!/bin/bash
#Usage   ./myscript.sh -e conf -s -l /usr/lib /etc/hosts 
VERSION="0.0.2"
BUG_EMAIL_ADDRESS="some@adress.com"
HOME_PAGE_ADDRESS="http://www.someweb.org/"
HELP_HOME_PAGE_ADDRESS="http://www.someweb.org/help/"

DEBUG_ENABLED=no
VERBOSE_ENABLED=no


function set_working_dir() {
cd $(dirname $0)
}



function set_script_dir_global_var(){
# If you changed your working dir before starting this function
# It will not work correctly!
# It must be called being in directory from which you started script
# that calling this funtion.
SCRIPT_DIR="$(dirname $(readlink -e $0))"
}


function set_base_dir_global_var(){
# SCRIPT_DIR variable must be set before use this function
# you can set SCRIPT_DIR variable be calling set_script_dir_global_var function
BASE_DIR="$(dirname $SCRIPT_DIR)"
}


function set_error_codes() {
SUCCESS=0
FAIL=1
ERROR__FILE_NOT_EXISTS=50
ERROR__NO_PERMISSIONS_TO_READ_FROM_FILE=51
ERROR__NO_PERMISSIONS_TO_WRITE_TO_FILE=52
ERROR__NO_PERMISSIONS_TO_EXECUTE_FILE=53
ERROR__SYMBOLIC_LINK_NOT_EXISTS=54
ERROR__DIRECTORY_NOT_EXISTS=55
ERROR__FILE_TOO_OLD=56
ERROR__FILE_TOO_NEW=57
ERROR__UNEXPECTED_VALUE_OF_VARIABLE=60
ERROR__UNEXPECTED_EMPTY_VALUE_OF_VARIABLE=61
ERROR__VARIABLE_NOT_SET=62
ERROR__PROCESS_DOES_NOT_EXISTS=63
ERROR__UNDEFINED_ERROR=66
}


function exit_with_msg() {
if [ $# -eq 1 ]
then
echo "Upps. Something went wrong.
	Exiting with return code $1.
	" >> /dev/stderr
exit $1
fi

}


function print_debug_msg() {
[ $VERBOSE_ENABLED = "yes" ] && echo "$1"
}

# f_log_msg() - Logging a message to log file
#
# Arguments: log_filename message_to_log
# Return: nothing
#
# Example; f_log_msg ../log/error.log "Error: Failure foo."
#
function f_log_msg() {
local log_file_name="$1"
[ ! -e ${log_file_name} ] && \
( [ ! -d  "$(dirname ${log_file_name})" ] && \
mkdir -p $(dirname ${log_file_name}) || \
touch ${log_file_name}; )

local log_date=`LC_ALL=C date "+%b %e %H:%M:%S"`
local log_host="$(hostname -s)"
local log_process="$(basename $0)"
local log_pid="$BASHPID"
shift
local log_msg="$@"
echo "$log_date $log_host $log_process[$log_pid]: $log_msg" >> "${log_file_name}"
}

function load_config_file() {
if [ -n "${1:-CONFIG_FILE_NAME_NOT_PASSED}" ]
then
[ ! -e "$1" ] && {
f_log_msg "error.log" "Error: Config file '$(readlink -m "$1")' not found.";
exit_with_msg $ERROR__FILE_NOT_EXISTS;
}
local tmp_file=$(mktemp)
cat "$1" | grep -Po "\w+\s?=\s?(\"[\w./]*\"|[\w.]*)" > "$tmp_file"
. "$tmp_file"
rm "$tmp_file"
fi
}


function parse_parameters() {
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
    -d|--debug)
    DEBUG_ENABLED=yes
    shift # past argument
    ;;
	-h|--help)
	echo "Usage:"
	echo "$0 [-c config_file]  [-l log_file]  [-v] [-d] <mandatory arg>"
#	echo "$0 [OPTION]... [FILE]..."
	echo "This command is doing this and this. General one line, short descr"
	echo
	echo -e "-v, --verbose\t\tprint more information"
	echo -e "-s, --search\t\tsearch path"
	echo -e "\t--help\t\tdisplay this help and exit"
	echo -e "\t--version\toutput version information and exit"
	echo
	echo "Examples:"
	echo -e "$0 -l /usr/lib -s /bin /etc/passwd\tfoo bar description"
	echo
	echo "Report bugs to $BUG_EMAIL_ADDRESS"
	echo "This soft home page: $HOME_PAGE_ADDRESS"
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
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo FILE EXTENSION  = "${EXTENSION}"
echo SEARCH PATH     = "${SEARCHPATH}"
echo LIBRARY PATH    = "${LIBPATH}"
echo DEFAULT         = "${DEFAULT}"
if [[ -n $1 ]]; then
   echo "Last argument: $1"
fi
}


set_error_codes
set_script_dir_global_var $0
set_base_dir_global_var 
set_working_dir $0
load_config_file "${SCRIPT_DIR}/my_config.cfg"
parse_parameters $@

