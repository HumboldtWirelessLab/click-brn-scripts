#define DEBUGLEVEL 2

#define LOGMARKEND

elementclass COMPRESSIONFILTER{ |

    //pc::PacketCompression(CMODE 0);
    pc::PacketCompression(CMODE 0, COMPRESSION 2, STRIPLEN 140);

    input[0]
    -> pc
    -> [0]output;

    pc[1]
    -> [0]output;
}

#define RAWDUMP
#define RAWFILTER cf::COMPRESSIONFILTER()

#define CST cst

#if WIFITYPE == 802

#if DEVICENUMBER == 0
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:12.0/stats/channel_utility"
#endif

#else

#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);


wifioutq::NotifierQueue(2000)
  -> wifidevice
  -> Discard;


/* R A T E S */

/* 80211ag */
  ee_g1::EtherEncap(0x8086, deviceaddress, ff-ff-ff-ff-ff-ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 12, TRIES0 1, MCS0 false )
  -> wifioutq;


//BRN2PacketSource(SIZE 150, INTERVAL 10, MAXSEQ 500000, BURST 6, PACKETCOUNT 1000000, ACTIVE true)
//BRN2PacketSource(SIZE 118, INTERVAL 5, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000000, ACTIVE true)
BRN2PacketSource(SIZE 118, INTERVAL 5, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000000, ACTIVE true)
-> ee_g1;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

