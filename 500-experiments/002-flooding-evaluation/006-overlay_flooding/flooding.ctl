#TIME NODE(S)   DEVICE  MODE    ELEMENT HANDLER  VALUE
100    sk1 DEV0    write   sf      add_flow sk1:eth FF-FF-FF-FF-FF-FF 1000 100 0 11000 true
220    ALL DEV0    read   flooding/fl stats
220    ALL DEV0    read   flooding/fl forward_table
220    ALL DEV0    read   flooding/fl_passive_ack stats
220    ALL DEV0    read   flooding/unicfl stats
220    ALL DEV0    read   sf stats
#221    ALL DEV0    read   flooding/ovl read_all_parents
#221    ALL DEV0    read   flooding/ovl read_own_parents
#221    ALL DEV0    read   flooding/ovl read_all_children
99    ALL DEV0    read   flooding/ovl read_own_children
220    FIRSTNODE DEV0    read   unicastsf stats
220    LASTNODE  DEV0    read   unicastsf stats
