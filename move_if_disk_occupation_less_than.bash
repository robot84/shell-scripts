#!/bin/bash
#
if [ $# -lt 2 ]
then
echo "Usage: ${0##*/} <source> <destination> [max disk usage in %]"
echo "Move file/directory if after movement on the destination partition still\
 will be more space than provided.
 "
echo
echo "[max disk usage in %] - if after movement there is more than this
percentage usage on destination disk -  we don't move anything.
If not specified, default value is 90 %
"
exit 1
fi

MOVE_FROM="$1"
MOVE_TO=$(readlink -m "$2")
THRESHOLD=90
[ -n "$3" ] && THRESHOLD="$3"
if [ ! -e "$MOVE_FROM" ]
then
echo "ERROR: source doesn't exists."
exit 1
fi
SRC_SIZE=$(du -s "$MOVE_FROM" | awk '{print $1}' )
DST_DISK=""
va=`df | awk '{print $6}' | grep -v "Mounted" | awk '{ print length, $1 }' | sort -n  | awk '{print $2}' `
v=($va)
for part in $va
do
echo $MOVE_TO | grep -q "$part" && DST_DISK=$part
done


DST_DISK_SIZE=$(df -P "$DST_DISK" | grep -v "Mounted" | awk '{print $6, $2, $3, $4}' | awk '{print $2}')
DST_DISK_OCCUPIED=$(df -P "$DST_DISK" | grep -v "Mounted" | awk '{print $6, $2, $3, $4}' | awk '{print $3}')

(( DST_DISK_PERCENT_OCCUPIED_AFTER_MOVING_YOUR_DIR = \
100 * ( $DST_DISK_OCCUPIED + $SRC_SIZE ) / $DST_DISK_SIZE ))

if [ $DST_DISK_PERCENT_OCCUPIED_AFTER_MOVING_YOUR_DIR -lt $THRESHOLD ]
then
mv  "$MOVE_FROM" "$MOVE_TO"
else
echo "$0: not enough space on destination partition"
exit 1
fi
