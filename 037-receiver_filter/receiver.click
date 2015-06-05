#define DEBUGLEVEL 2

elementclass COMPRESSIONFILTER{ |

    //pc::PacketCompression(CMODE 0);
    pc::PacketCompression(CMODE 0, COMPRESSION 2, STRIPLEN 100);

    input[0]
    -> pc
    -> [0]output;

    pc[1]
    -> [0]output;
}

#define TMPDUMP
#define RAWDUMP
#define RAWFILTER cf::COMPRESSIONFILTER()

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawdev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle
  -> wifidevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> discard::Discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
 wait 5,
 read sys_info.systeminfo,
 read id.version
);