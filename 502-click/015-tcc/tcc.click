RatedSource(\<080012345678>, 10, 1000)
-> tcc::TCC()
-> Discard;


Script(
  wait 1,
  write tcc.code

               int click_tcc_init() {
                 printf("Hallo\n");
                 return 0;
               }

               int click_tcc_close() {
                 printf("good bye\n");
                 return 0;
               }

               void* click_tcc_simple_action(void *p) {
                 printf("Handle p. Size: %d\n"@tcc_packet_size(p));
                 return p;
               }

               ,
  wait 1,
  write tcc.code

               int click_tcc_init() {
                 printf("Hallo\n");
                 return 0;
               }

               void* click_tcc_simple_action(void *p) {
                 printf("Handle2 p. Size: %d\n"@tcc_packet_size(p));
                 return p;
               }

               ,
  wait 1,
  stop
);
