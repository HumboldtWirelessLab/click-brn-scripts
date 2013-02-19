#!/bin/sh

#XSTART=20 XLIM=30 YSTART=0 YLIM=30 ./gen_random_box_plm.sh 10

NO_NODES=25

if [ "x$1" != "x" ]; then
  NO_NODES=$1
fi

if [ "x$XLIM" = "x" ]; then
  XLIM=50
fi

if [ "x$YLIM" = "x" ]; then
  YLIM=50
fi

if [ "x$XSTART" = "x" ]; then
  XSTART=50
fi

if [ "x$YSTART" = "x" ]; then
  YSTART=50
fi

y=`expr \( $YLIM / 2 \) + $YSTART`

echo "sk1 0 $y 0"

for i in `seq 2 $NO_NODES`; do
  x=`expr \( $RANDOM \% $XLIM \) + $XSTART`
  y=`expr \( $RANDOM \% $YLIM \) + $YSTART`

  echo "sk$i $x $y 0"
done
