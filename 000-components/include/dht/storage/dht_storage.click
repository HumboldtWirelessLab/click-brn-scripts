elementclass DHT_STORAGE { DHTROUTING $dhtrouting, DEBUG $debug |
  brndb :: BRNDB(DEBUG $debug);
  dhtstorageruph :: DHTStorageSimpleRoutingUpdateHandler(DB brndb, DHTROUTING $dhtrouting, DEBUG $debug);
  dhtstorage :: DHTStorageSimple(DB brndb, DHTROUTING $dhtrouting, ADDNODEID true, DEBUG $debug );

  input[0] 
    -> dhtstorage_cfl :: Classifier( 1/01, - )
    //-> Print("Storage in")
    -> dhtstorage
    //-> Print("Storage out")
    -> [0]output;
    
  dhtstorage_cfl[1]
    -> dhtstorageruph
    -> [0]output;
}

