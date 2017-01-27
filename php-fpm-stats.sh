#!/bin/bash
### OPTIONS VERIFICATION
if [[ -z "$1" || -z "$2" || -z "$3" ]]; then exit 1; fi
##### PARAMETERS #####
RESERVED="$1"
METRIC="$2"
STATSURL="$3"
#
CURL="/usr/bin/curl"
TTLCACHE="55"
FILECACHE="/tmp/zabbix.php-fpm-stats.cache"
TIMENOW=`date '+%s'`
##### RUN #####

if [ -s "$FILECACHE" ]; then TIMECACHE=`stat -c"%Z" "$FILECACHE"`; else TIMECACHE=0; fi

if [ "$(($TIMENOW - $TIMECACHE))" -gt "$TTLCACHE" ]; then 
     echo "" >> $FILECACHE
     DATACACHE=`$CURL --insecure -s "$STATSURL"` || exit 1
     echo "$DATACACHE" > $FILECACHE # !!!
fi

case "$METRIC" in
 "total")    total=`cat $FILECACHE | grep total | awk '{ print $3 }'`
             if [ "$total" ]; then echo "$total"; else echo "0"; fi
             ;;
 "active")   active=`cat $FILECACHE | grep active | head -1 | awk '{print $3}'`
             if [ "$active" ]; then echo "$active"; else echo "0"; fi
             ;;
 "idle")     idle=`cat $FILECACHE | grep idle | awk '{print $3}'`
             if [ "$idle" ]; then echo "$idle"; else echo "0"; fi
             ;;
 "max")      max=`cat $FILECACHE | grep 'max active' | awk '{print $4}'`
             if [ "$max" ]; then echo "$max"; else echo "0"; fi
             ;;
 *)          ;;
esac

exit 0
