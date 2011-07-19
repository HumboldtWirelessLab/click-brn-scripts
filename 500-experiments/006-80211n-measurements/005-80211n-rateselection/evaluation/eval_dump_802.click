FromDump("DUMP",STOP true)
  -> packets :: Counter
  -> maxl :: CheckLength(4)
  -> minl :: CheckLength(3)[1]
  -> toosmall :: Counter
  -> Discard;

minl
  -> Print("DumpError", TIMESTAMP true)
  -> Discard;


print_seq::Null()
  -> Strip(16)
  -> Print(LABEL "Content", LENGTH 4)
  -> Discard;

maxl[1]
  -> rtap_decap :: BrnRadiotapDecap()
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket", PRINTHT true, PRINTRXSTATUS false, PRINTEVM false, TIMESTAMP true, NOWRAP true)
  -> foo :: CheckLength(16)
  -> Print(LABEL "trash")
  -> Discard;

foo[1]
  -> WifiDecap()
  -> print_seq;

error_clf[1]
  -> BRN2PrintWifi("CRCerror", PRINTHT true, PRINTRXSTATUS false, PRINTEVM false, TIMESTAMP true, NOWRAP true)
  -> print_seq;


filter_tx[1]
  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> Discard;
