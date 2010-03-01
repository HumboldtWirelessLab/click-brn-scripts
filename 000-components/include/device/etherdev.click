elementclass RAWETHERDEV { DEVNAME $devname |

  input[0]
//-> Print("To Device")
  -> toDevice::ToSimDevice($devname);
  
  FromSimDevice($devname, SNAPLEN 1500)
//-> Print("From Device")
  -> SetTimestamp()
  -> [0]output;
  
} 

