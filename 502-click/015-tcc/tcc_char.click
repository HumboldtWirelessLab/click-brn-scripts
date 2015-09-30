Idle()
-> tcc::TCC(DEBUG 2)
-> Discard;

Script(
  write tcc.add char* power char*,
  write tcc.compile

               char* power(char *a) {
                 printf("Hallo %s\n"@a);
                 return a;
               }
               ,
  write tcc.call power FOO,
  read tcc.result,
  wait 1,
  stop
);