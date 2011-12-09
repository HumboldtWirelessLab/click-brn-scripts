#!/bin/sh

FINDIR=`date +%Y-%m-%d-%r`
RESULTBASEDIR=/testbedhome/testbed/tmp/measurements/aci

FDIR=$RESULTBASEDIR/$FINDIR

echo "Create targetdir"
if [ ! -e $FDIR ]; then
  mkdir $FDIR
fi

echo "Start evaluation"
(cd evaluation;./eval.sh ../ )

echo "Copy result"
mv 5GHz_*_ratepair_* $FDIR/
mv 5GHz_init_* $FDIR/
mv evaluation/*.avi $FDIR/
mv evaluation/result* $FDIR/

echo "Save old configfile"
if [ ! -e 5Ghz.setup.bak ]; then
  mv 5Ghz.setup 5Ghz.setup.bak
  mv 5Ghz.setup.new 5Ghz.setup
fi

echo "Fertig"
echo "Ergebnisse liegen unter $FDIR"
echo "Neue Messung vorbereiten"
echo "Auto auf Start stellen: hintere rechte rad ist in Fahrtrichtung links von der Markierung, vordere rechte Rad steht auf der Markierung"
echo "Richtung des Auto mit Auge ueberpruefen"
echo "Roten Knopf an Lego-Kasten (Gelb) druecken, wenn nichts auf dem Display zu sehen ist"
echo "Dann enter druecken"

read key

T=n

while [ "x$T" = "xn" ]; do
  T=y
  ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 3"
  echo "Gab's einen Ton ?. Wenn nicht, dann Legokasten pruefen und Taste 'n' druecken und dann  'enter' druecken."
  echo "Wenn ein Ton kam, dann nur 'enter' druecken."
  read T
done

echo "Neue messung nun innerhalb der naechsten 10 Minuten manuell starten mit:"
echo "./aci_measurement.sh 5Ghz.setup"

exit 0
