#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define RAWDUMP
//#define RAWDUMPSNAPLEN 100

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket (NODENAME)", TIMESTAMP true)
  -> tcc::TCC()
  -> discard::Discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
 wait 5,
 read sys_info.systeminfo,
 read id.version,
 read error_clf.stats,
 read wifidevice/cst.stats
);

Script(
  wait 1,
  write tcc.code

               int click_tcc_init() {
                 printf("Hallo\n");
                 return 0;
               }

               int click_tcc_close() {
                 printf("good bye\n");
                 return 0;
               }

               void* click_tcc_simple_action(void *p) {
                 printf("Handle p. Size: %d\n"@tcc_packet_size(p));
                 return p;
               }

               ,
  wait 1,
  write tcc.code

               int click_tcc_init() {
                 printf("Hallo\n");
                 return 0;
               }

               void* click_tcc_simple_action(void *p) {
                 printf("Handle2 p. Size: %d\n"@tcc_packet_size(p));
                 return p;
               }

               ,
  wait 1,
  stop
);
