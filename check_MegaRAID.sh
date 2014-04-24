#!/bin/sh
# Check LSI MegaRAID through Powershell socket

TCP_PORT=63560
NETCAT=$(which netcat)

while getopts H: opts; do
   case ${opts} in
     H) HOST=${OPTARG} ;;
   esac
done

if [ -z "$HOST" ]
then
   echo "USAGE: $0 -H host"
   exit 3
fi

SOCKET=$(echo GET | $NETCAT -w 7 $HOST $TCP_PORT)
        if [ $? -ne 0 ]; then
           echo "WARNING - Connection to $HOST on port $TCP_PORT failed."
           exit 1
        fi

LINECOUNT=$(printf "%s\n" "$SOCKET" | grep -i Optimal | wc -l)
        if [ $LINECOUNT -eq 2 ]; then
           echo "OK - Both disk arrays in Optimal state."
           exit 0 #Optimal is returned twice. Both arrays are in "Optimal" state.
        else
           echo "CRITICAL - Exit with code 2. One or more disk arrays degraded!"
           exit 2
        fi
