#define DEBUGLEVEL 2

#define LOGMARKEND

elementclass COMPRESSIONFILTER{ |

    //pc::PacketCompression(CMODE 0);
    pc::PacketCompression(CMODE 0, COMPRESSION 2, STRIPLEN 96);

    input[0]
    -> pc
    -> [0]output;

    pc[1]
    -> [0]output;
}

#define RAWDUMPSNAPLEN 100
#define TMPDUMP
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

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

  Idle()
  -> wifidevice
  -> Discard;



/*
Script(
wait 5,
read wifidevice/cst.stats,
wait 5,
read wifidevice/cst.stats,
wait 5,
read wifidevice/cst.stats
);
*/

Script(
wait 10,
read wifidevice/cst.stats,
loop
);
