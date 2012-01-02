#!/bin/sh

#cat $1 | grep -v "#" | awk '{print $1}' | sed "s#[a-z]*##g" | awk '{print "192.168.3."$0}'
for i in `cat $1 | awk '{print $1}'`; do nslookup $i; done | grep Address | grep -v "#" | awk '{print $2}'

