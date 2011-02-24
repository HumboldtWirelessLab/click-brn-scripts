src::FromSocket("UDP", 127.0.0.1, 8086);
dst::ToSocket("UDP", 192.168.3.2, 8090);
AddressInfo(deviceaddress eth0:eth);

src
//-> Print("Data",48,TIMESTAMP true)
-> Queue()
-> EtherEncap(0x0888, deviceaddress, 00:11:11:d1:dd:8c)
//-> Print("Data2",48,TIMESTAMP true)
//-> ToDump("data.dump");
-> dst;
