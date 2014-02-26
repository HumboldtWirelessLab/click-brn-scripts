#TIME NODE(S)   DEVICE  MODE    ELEMENT HANDLER  VALUE
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-08 00-00-00-00-00-07
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-07 00-00-00-00-00-08
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-09 00-00-00-00-00-0A
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-0A 00-00-00-00-00-09
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-01 00-00-00-00-00-05
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-05 00-00-00-00-00-01
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-07 00-00-00-00-00-03
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-03 00-00-00-00-00-01
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-01 00-00-00-00-00-02
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-02 00-00-00-00-00-07
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-04 00-00-00-00-00-08
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-08 00-00-00-00-00-04
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-05 00-00-00-00-00-09
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-09 00-00-00-00-00-06
90    ALL DEV0    write   flooding/ovl add_child 00-00-00-00-00-06 00-00-00-00-00-05
100    sk1 DEV0    write   sf      add_flow sk1:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
112    sk2 DEV0    write   sf      add_flow sk2:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
124    sk3 DEV0    write   sf      add_flow sk3:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
136    sk4 DEV0    write   sf      add_flow sk4:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
148    sk5 DEV0    write   sf      add_flow sk5:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
160    sk6 DEV0    write   sf      add_flow sk6:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
172    sk7 DEV0    write   sf      add_flow sk7:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
184    sk8 DEV0    write   sf      add_flow sk8:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
196    sk9 DEV0    write   sf      add_flow sk9:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
208    sk10 DEV0    write   sf      add_flow sk10:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
220    sk1 DEV0    read   flooding/fl stats
220    sk1 DEV0    read   flooding/fl forward_table
220    sk1 DEV0    read   flooding/fl_passive_ack stats
220    sk1 DEV0    read   flooding/unicfl stats
220    sk1 DEV0    read   sf stats
220    sk2 DEV0    read   flooding/fl stats
220    sk2 DEV0    read   flooding/fl forward_table
220    sk2 DEV0    read   flooding/fl_passive_ack stats
220    sk2 DEV0    read   flooding/unicfl stats
220    sk2 DEV0    read   sf stats
220    sk3 DEV0    read   flooding/fl stats
220    sk3 DEV0    read   flooding/fl forward_table
220    sk3 DEV0    read   flooding/fl_passive_ack stats
220    sk3 DEV0    read   flooding/unicfl stats
220    sk3 DEV0    read   sf stats
220    sk4 DEV0    read   flooding/fl stats
220    sk4 DEV0    read   flooding/fl forward_table
220    sk4 DEV0    read   flooding/fl_passive_ack stats
220    sk4 DEV0    read   flooding/unicfl stats
220    sk4 DEV0    read   sf stats
220    sk5 DEV0    read   flooding/fl stats
220    sk5 DEV0    read   flooding/fl forward_table
220    sk5 DEV0    read   flooding/fl_passive_ack stats
220    sk5 DEV0    read   flooding/unicfl stats
220    sk5 DEV0    read   sf stats
220    sk6 DEV0    read   flooding/fl stats
220    sk6 DEV0    read   flooding/fl forward_table
220    sk6 DEV0    read   flooding/fl_passive_ack stats
220    sk6 DEV0    read   flooding/unicfl stats
220    sk6 DEV0    read   sf stats
220    sk7 DEV0    read   flooding/fl stats
220    sk7 DEV0    read   flooding/fl forward_table
220    sk7 DEV0    read   flooding/fl_passive_ack stats
220    sk7 DEV0    read   flooding/unicfl stats
220    sk7 DEV0    read   sf stats
220    sk8 DEV0    read   flooding/fl stats
220    sk8 DEV0    read   flooding/fl forward_table
220    sk8 DEV0    read   flooding/fl_passive_ack stats
220    sk8 DEV0    read   flooding/unicfl stats
220    sk8 DEV0    read   sf stats
220    sk9 DEV0    read   flooding/fl stats
220    sk9 DEV0    read   flooding/fl forward_table
220    sk9 DEV0    read   flooding/fl_passive_ack stats
220    sk9 DEV0    read   flooding/unicfl stats
220    sk9 DEV0    read   sf stats
220    sk10 DEV0    read   flooding/fl stats
220    sk10 DEV0    read   flooding/fl forward_table
220    sk10 DEV0    read   flooding/fl_passive_ack stats
220    sk10 DEV0    read   flooding/unicfl stats
220    sk10 DEV0    read   sf stats
221    ALL DEV0    read   flooding/ovl read_all_parents
221    ALL DEV0    read   flooding/ovl read_own_parents
221    ALL DEV0    read   flooding/ovl read_all_children
221    ALL DEV0    read   flooding/ovl read_own_children
220    FIRSTNODE DEV0    read   unicastsf stats
220    LASTNODE  DEV0    read   unicastsf stats
