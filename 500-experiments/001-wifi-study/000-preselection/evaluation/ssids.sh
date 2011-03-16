cat $1 | grep -P "beacon" | grep -P "OKPacket:" | awk '{ print $75 }' | sort -u
