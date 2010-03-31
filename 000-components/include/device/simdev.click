elementclass RAWDEV { DEVNAME $devname, DEVICE $device |

  input[0]
  -> BRN2SetDeviceAnno(DEVICE $device)
  //-> ExtraEncap()
  -> AddEtherNsclick()
  //-> Print("To Device")
  -> toDevice::ToSimDevice($devname);
  
  FromSimDevice($devname, SNAPLEN 1500)
  -> Strip(14)
  //-> ExtraDecap()
  //-> Print("From Device")
  -> SetTimestamp()
  -> [0]output;
  
} 

