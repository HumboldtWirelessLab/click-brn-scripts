elementclass RAWDEV { DEVNAME $devname |

  input[0]
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

