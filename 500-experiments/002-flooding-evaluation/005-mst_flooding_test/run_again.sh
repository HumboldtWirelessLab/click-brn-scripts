#!/bin/sh
echo "Running NS2"
/usr/bin/time --quiet -f %E -o /home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/time.stats ns /home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/mstflooding.tcl > /home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/measurement.log 2>&1
