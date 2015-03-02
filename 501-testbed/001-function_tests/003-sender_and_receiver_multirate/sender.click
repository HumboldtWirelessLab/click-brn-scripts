#define DEBUGLEVEL 2

//#define RAWDUMP 1

#define CST cst

#if WIFITYPE == 803

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

rates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);
rs_rr::BrnRoundRobinRate();

ratesel::SetTXPowerRate( RATESELECTIONS "rs_rr", STRATEGY 6, RT rates);

Idle()
-> sf::BRN2SimpleFlow(FLOW "deviceaddress FF:FF:FF:FF:FF:FF 25 15 0 4500 true 1 0", DEBUG 2)
-> BRN2EtherEncap(USEANNO true)
-> WifiEncap(0x00, 0:0:0:0:0:0)
-> [0]ratesel[0]
-> NotifierQueue(1000)
-> wifidevice
-> Discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
