#!/bin/sh

cd example
Rscript ../calc_articulation_points.R
Rscript ../calc_bridges.R
Rscript ../calc_f1_measure.R
