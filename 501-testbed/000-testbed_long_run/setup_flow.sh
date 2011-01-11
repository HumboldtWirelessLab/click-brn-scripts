#!/bin/sh

cat dsr_flow_ctrl.tmpl | sed "s#node1#$1#g" | sed "s#node2#$2#g" > dsr_flow.ctl
handler_control.sh dsr_flow.ctl 1/nodes.mac | human_readable.sh
rm dsr_flow.ctl