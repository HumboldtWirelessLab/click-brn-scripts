#!/bin/sh

LIMIT=7
i=1

while [ $i -le $LIMIT ]; do
  NUM=`printf "%03d\n" $i`
  DIR=`ls -l | awk '{print $8}' | grep "$NUM-"`
  echo -n "Test $DIR "
  DESFILE=`(cd $DIR; ls *.des)`
  echo -n "($DESFILE) ... "
  (cd $DIR; run_sim.sh ns $DESFILE 1) > /dev/null 2>&1
  if [ $? -ne 0 ]; then 
    echo "failed !";
  else
    echo "ok."
  fi
  (cd $DIR; rm -rf 1/)
  
  i=`expr $i + 1`
done