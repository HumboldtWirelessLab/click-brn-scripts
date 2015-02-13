#!/bin/bash
if [ x$# == x2 ]; then
	cat $1|NUM2MAC=1 human_readable.sh $2|sed 's/ -1/FF-FF-FF-FF-FF-FF/g';
	exit;
fi
echo 'Call with convert_to_mac.sh circle_path nodes.mac';
