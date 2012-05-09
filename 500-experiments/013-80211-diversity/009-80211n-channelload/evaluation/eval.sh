#!/bin/sh

function mac_to_num() {
  NODEMAC_SEDARG=""

  if [ "x$1" != "x" ]; then
    while read line; do
      NODENAME=`echo $line | awk '{print $1}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      NODENUM=`echo $line | awk '{print $4}'`
      if [ "x$2" != "x" ]; then
        NODENUM=`cat $2 | grep $NODENAME | awk '{print $2}'`
      fi
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g -e s#$NODENAME#$NODENUM#g"
    done < $1
  fi

  # echo $NODEMAC_SEDARG >&2
  sed $NODEMAC_SEDARG
}

CDIR=$PWD

TARGET=$1

if [ -e $TARGET/params ]; then
  . $TARGET/params
  FILENAME=$TARGET/result_channel_$PARAMS_CHANNEL.csv
  MATFILENAME=$TARGET/result_channel_$PARAMS_CHANNEL.mat
else
  FILENAME=$TARGET/result.csv
  MATFILENAME=$TARGET/result.mat
fi


rm -f $FILENAME

if [ ! -f $FILENAME ]; then

echo -n "" > $FILENAME

(cd $TARGET;ls *wlan0.log) > /dev/null 2>&1

if [ $? -eq 0 ]; then
  for l in `(cd $TARGET; ls *wlan0.log)`; do
    echo "<channelloadmeasurement>" > $TARGET/$l.xml
    (cd $TARGET; cat $l | grep -e "^[[:space:]]*<") >> $TARGET/$l.xml
    echo "</channelloadmeasurement>" >> $TARGET/$l.xml
    (cd $TARGET; xsltproc ../evaluation/mobilemeasurement.xslt $l.xml | mac_to_num nodes.mac $CDIR/$2 | grep -v "0.000000") >> $FILENAME
  done
fi

(cd $TARGET;ls *wlan1.log) > /dev/null 2>&1

if [ $? -eq 0 ]; then
  for l in `(cd $TARGET; ls *wlan1.log)`; do
    echo "<channelloadmeasurement>" > $TARGET/$l.xml
    (cd $TARGET; cat $l | grep -e "^[[:space:]]*<") >> $TARGET/$l.xml
    echo "</channelloadmeasurement>" >> $TARGET/$l.xml
    (cd $TARGET; xsltproc ../evaluation/mobilemeasurement.xslt $l.xml | mac_to_num nodes.mac $CDIR/$2 | grep -v "0.000000" ) >> $FILENAME
  done
fi

fi

cat $FILENAME | sed "s#,# #g" > $MATFILENAME
cp $MATFILENAME $MATFILENAME.txt
