elementclass RAWETHERDEV { DEVNAME $devname, DEVICE $device |

  input[0]
  -> BRN2SetDeviceAnno(DEVICE $device)
//-> Print("To Device")
  -> toDevice::ToSimDevice($devname);
  
  FromSimDevice($devname, SNAPLEN 1500)
//-> Print("From Device")
  -> SetTimestamp()
  -> [0]output;
  
} 

