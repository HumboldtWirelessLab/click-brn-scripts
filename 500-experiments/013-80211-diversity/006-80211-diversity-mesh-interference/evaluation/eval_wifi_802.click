FromDump("DUMP",STOP true)
  -> packets :: Counter
  -> pdc::PacketDecompression(CMODE 0)
  -> n::Null();
  pdc[1]
  -> n
  -> maxl :: CheckLength(4)
  -> minl :: CheckLength(3)[1]
  -> Print("Sync", TIMESTAMP true)
  -> toosmall :: Counter
  -> Discard;

minl
  -> Print("DumpError", TIMESTAMP true)
  -> Discard;

maxl[1]
//GPS  -> GPSPrint(NOWRAP true)
//GPS  -> GPSDecap()
  -> rtap_decap :: BrnRadiotapDecap()
  -> Print("RAW") //just for linebreak
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> ok :: Counter
  -> BRN2PrintWifi("OKPacket", PRINTHT PARAMS_HT, PRINTRXSTATUS PARAMS_RX, PRINTEVM PARAMS_EVM, TIMESTAMP true, NOWRAP NOWRAP_PARAMS)
  -> WifiDecap()
//WRAP -> Print()
//SEQ  -> seq_clf :: Classifier( 12/8088, - )
//SEQ  -> Print("ReferenceSignal", TIMESTAMP true)
  -> Discard;

//SEQ seq_clf[1]
//SEQ -> Discard;

error_clf[1]
  -> crc :: Counter
  -> BRN2PrintWifi("CRCerror", PRINTHT PARAMS_HT, PRINTRXSTATUS PARAMS_RX, PRINTEVM PARAMS_EVM, TIMESTAMP true, NOWRAP NOWRAP_PARAMS)
  -> WifiDecap()
//WRAP -> Print()
  -> Discard;


filter_tx[1]
  -> txpa :: Counter
  -> BRN2PrintWifi("TXFeedback", PRINTHT PARAMS_HT, PRINTRXSTATUS PARAMS_RX, PRINTEVM PARAMS_EVM, TIMESTAMP true, NOWRAP NOWRAP_PARAMS)
  -> WifiDecap()
//WRAP -> Print()
  -> Discard;
