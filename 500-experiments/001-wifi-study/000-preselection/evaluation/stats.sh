echo "Usage: stats.sh <directory> <device>"

source $1/config

WIFI=805 GPS=yes ATH=yes SEQ=yes fromdump.sh $1/devel.$2.dump > $1/devel.$2.dat

if [ "$HOPPINGDEVICE" = $2 ]
then
    echo "analyzing hopping device"

    for i in $HOPPINGCHANNELS; do 
	ok_packet_num=`cat $1/devel.$2.dat | grep "OKPacket:" | awk '{print $52" "$53}' | grep "^Channel: $i$" | wc -l; `
	crc_packet_num=`cat $1/devel.$2.dat | grep "CRCerror:" | awk '{print $52" "$53}' | grep "^Channel: $i$" | wc -l; `
	tx_feedback_num=`cat $1/devel.$2.dat | grep "Feedback" | awk '{print $52" "$53}' | grep "^Channel: $i$" | wc -l; `
	echo "device: $2 channel: $i ok_packet: $ok_packet_num crc_packet: $crc_packet_num txfeedback: $tx_feedback_num";
    done
else

	ok_packet_num=`cat $1/devel.$2.dat | grep "OKPacket:" | wc -l; `
	crc_packet_num=`cat $1/devel.$2.dat | grep "CRCerror:" | wc -l; `
	tx_feedback_num=`cat $1/devel.$2.dat | grep "Feedback" | wc -l; `
	echo "device: $2 ok_packet: $ok_packet_num crc_packet: $crc_packet_num txfeedback: $tx_feedback_num";
fi


