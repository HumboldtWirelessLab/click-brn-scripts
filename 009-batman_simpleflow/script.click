#ifdef ENABLE_SCRIPT
Script(
//  write sf.debug 4,
#ifdef ENABLE_BATMAN_DEBUG
  write batman/bofwd.debug 4,
  write batman/bf.debug 4,
  write batman/br.debug 4,
#endif
//  wait 40,
//  read batman/brt.nodes,
    wait 200,
    read batman/brt.nodes,
    wait 17,
    read batman/bfd.info,    
    wait 1,
    read batman/bofwd.links,    
    wait 1,
    stop
);
#endif
