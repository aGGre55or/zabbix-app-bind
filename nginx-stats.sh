#!/bin/bash
### OPTIONS VERIFICATION
if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
exit 1
fi
##### PARAMETERS #####
RESERVED="$1"
METRIC="$2"
STATSURL="$3"
#
CURL="/usr/bin/curl"
TTLCACHE="55"
FILECACHE="/tmp/zabbix.nginx.`echo $STATSURL | md5sum | cut -d" " -f1`.cache"
TIMENOW=`date '+%s'`
##### RUN #####
if [ -s "$FILECACHE" ]; then
TIMECACHE=`stat -c"%Z" "$FILECACHE"`
else
TIMECACHE=0
fi
if [ "$(($TIMENOW - $TIMECACHE))" -gt "$TTLCACHE" ]; then
echo "" >> $FILECACHE # !!!
DATACACHE=`$CURL --insecure -s "$STATSURL"` || exit 1
echo "$DATACACHE" > $FILECACHE # !!!
fi
if [ "$METRIC" = "active" ]; then
active=`cat $FILECACHE | grep "Active connections" | cut -d':' -f2`; active=${active:1}
if [ "$active" ]; then echo "$active"; else echo "0"; fi
fi
if [ "$METRIC" = "accepts" ]; then
accepts=`cat $FILECACHE | sed -n '3p' | cut -d" " -f2`
if [ "$accepts" ]; then echo "$accepts"; else echo "0"; fi
fi
if [ "$METRIC" = "handled" ]; then
handled=`cat $FILECACHE | sed -n '3p' | cut -d" " -f3`
if [ "$handled" ]; then echo "$handled"; else echo "0"; fi
fi
if [ "$METRIC" = "requests" ]; then
requests=`cat $FILECACHE | sed -n '3p' | cut -d" " -f4`
if [ "$requests" ]; then echo "$requests"; else echo "0"; fi
fi
if [ "$METRIC" = "reading" ]; then
reading=`cat $FILECACHE | grep "Reading" | cut -d':' -f2 | cut -d' ' -f2`
if [ "$reading" ]; then echo "$reading"; else echo "0"; fi
fi
if [ "$METRIC" = "writing" ]; then
writing=`cat $FILECACHE | grep "Writing" | cut -d':' -f3 | cut -d' ' -f2`
if [ "$writing" ]; then echo "$writing"; else echo "0"; fi
fi
if [ "$METRIC" = "waiting" ]; then
waiting=`cat $FILECACHE | grep "Waiting" | cut -d':' -f4 | cut -d' ' -f2`
if [ "$waiting" ]; then echo "$waiting"; else echo "0"; fi
fi
#
exit 0
