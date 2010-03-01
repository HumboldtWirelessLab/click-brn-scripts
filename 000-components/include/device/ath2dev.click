elementclass RAWDEV { DEVNAME $devname |

  input[0]
  -> AddEtherNsclick()
//-> Print("To Device")
  -> toDevice::ToSimDevice($devname);
  
  FromSimDevice($devname, SNAPLEN 1500)
  -> Strip(14)
//-> Print("From Device")
  -> output[0];
  
} 
