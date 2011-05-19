#define DEBUGLEVEL 2

#define RECEIVE_ONLY

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);

wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(wireless);

wifidevice::RAWWIFIDEV(DEVNAME "NODEDEVICE", DEVICE wireless);

Idle
-> wifidevice
//  -> p::Counter()
//  -> td :: TODUMP("RESULTDIR/NODENAME.NODEDEVICE.dump");
//  -> td :: ToDump("/tmp/extra/test/NODENAME.NODEDEVICE.dump");
    -> Discard;

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif



//SYNC
//  -> td;
