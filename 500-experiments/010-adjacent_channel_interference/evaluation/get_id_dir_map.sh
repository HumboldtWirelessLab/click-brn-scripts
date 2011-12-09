#!/bin/sh

if [ "x$1" = "x" ]; then
  RESULTDIR="./"
else
  RESULTDIR="$1/"
fi

ID=0

PREFIXES=""

echo "$ID $i" > id_dir.map

for d in `(cd $RESULTDIR; ls -d *_init_0*) | grep -v "_channel_mobil_"`; do
  PREFIX=`(cd $RESULTDIR; echo "$d" | sed -e "s#_init*# #g" | awk '{print $1}')`
  PREFIXES="$PREFIXES $PREFIX"
done

for p in $PREFIXES; do

  for i in `(cd $RESULTDIR; ls -d $p\_init_* | grep -v "_channel_mobil_")`; do

    if [ -e $RESULTDIR/$i/params ]; then
      echo "$ID $i" >> id_dir.map

      ID=`expr $ID + 1`
    fi
  done

  for i in `(cd $RESULTDIR; ls -d $p*_ratepair_*)`; do

    if [ -e $RESULTDIR/$i/params ]; then
      echo "$ID $i" >> id_dir.map

      ID=`expr $ID + 1`

    fi
  done
done

