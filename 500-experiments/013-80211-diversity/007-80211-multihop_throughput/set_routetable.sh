#!/bin/sh

# Setzen der Routen in einem ad-hoc-netzwerk

export PATH=$PATH:/bin:/sbin:/usr/sbin:/usr/bin

USEDEV=wlan1

# iwconfig wlan0 ip setzen
NR=`ifconfig eth0 | grep "inet addr" | sed "s#\.# #g" | awk '{print $5}'`
ifconfig $USEDEV 10.0.0.$NR  

TABLE=table.txt

route del -net 10.0.0.0/8

while read line; do
	if [ ! "x$line" = "x" ]; then	
		
		SRC=`echo $line | awk '{print $1}'`
		DST=`echo $line | awk '{print $2}'`
		HOP=`echo $line | awk '{print $3}'`
		
		if [ "x$SRC" = "x$NR" ]; then 
			if [ "x$DST" = "x$HOP" ]; then
				echo "route add -host 10.0.0.$DST dev $USEDEV metric 2"
				route add -host 10.0.0.$DST dev $USEDEV metric 2
			else
				echo "route add -host 10.0.0.$DST gw 10.0.0.$HOP metric 2"
				route add -host 10.0.0.$DST gw 10.0.0.$HOP metric 2
			fi
		fi
	fi
done < $TABLE 

