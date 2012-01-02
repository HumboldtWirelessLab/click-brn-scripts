#define DEBUGLEVEL 2

//#define RAWDUMP 1
#define RAWDEV_DEBUG 1

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::BRN2PacketSource(SIZE 8, INTERVAL 100, MAXSEQ 500000, BURST 12, PACKETCOUNT 10000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:FF:FF)
  -> SetTXRate( RATE 4 )
  -> SetTXPower( 4 )
  -> BRN2SetChannel(CHANNEL 42)
  -> SetTimestamp()
  -> wifioutq::NotifierQueue(1000)
  -> SetTimestamp()
  -> wifidevice
  -> Print("Foo")
  -> ToDump(FILENAME "RESULTDIR/NODENAME.NODEDEVICE.raw.dump", EXTRA_LENGTH false, UNBUFFERED true)
  -> Discard;
