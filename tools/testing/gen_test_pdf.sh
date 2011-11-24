#!/bin/sh

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
  "/")
     DIR=$dir
     ;;
  ".")
     DIR=$pwd/$dir
     ;;
   *)
     echo "Error while getting directory"
     exit -1
     ;;
esac

LIMIT=$LIMIT
i=$START

TOPDIR=$PWD
CURRENT_DIR=$PWD

cat $DIR/share/main.tex > testbed.tex

cp $DIR/share/IEEEtran* .

if [ "x$MODE" = "xSIMULATION" ]; then
  MODESTRING="Simulation"
fi

echo "\input{summary}" >> testbed.tex

echo "\section{Summary}" > summary.tex

echo "\begin{table}[h]" >> summary.tex
echo "\centering" >> summary.tex
echo "\begin{tabular}{p{.55\textwidth}p{.20\textwidth}p{.20\textwidth}}" >> summary.tex
echo "\colheadbegin \textbf{Scenario} & \textbf{$MODESTRING} & \textbf{Evaluation}" >> summary.tex
echo "\colheadend" >> summary.tex

mkdir -p img

while [ $i -le $LIMIT ]; do
  MEASUREMENTNUM=$RANDOM
  NUM=`printf "%03d\n" $i`
  WORKDIR=`ls -l | awk '{print $8}' | grep "$NUM-"`
  NAME=`echo $WORKDIR | sed "s#$NUM-##g" | sed "s#_# #g"`
  DESCRIPTIONFILE=`(cd $WORKDIR;ls *.des | awk '{print $1}')`
  echo -n "Test $WORKDIR "
  echo "\section{$NAME}" >> testbed.tex
  echo "\subsection{Output}" >> testbed.tex


  if [ "x$MODE" = "xSIMULATION" ]; then
    (cd $WORKDIR; EVAL_LOG_OUT=3 run_sim.sh ns $DESCRIPTIONFILE $MEASUREMENTNUM) 1> /dev/null 3>> testbed.tex
    RESULT=$?
  else
    if [ "x$MODE" = "xMEASUREMENT" ]; then
      (cd $WORKDIR; EVAL_LOG_OUT=3 RUNMODE=REBOOT run_measurement.sh $DESCRIPTIONFILE $MEASUREMENTNUM ) >> testbed.tex 3>&1
      RESULT=$?
    else
      RESULT=1
    fi
  fi
  
  echo "\subsection{Result}" >> testbed.tex
  
  if [ $RESULT -ne 0 ]; then 
    if [ $RESULT -eq 1 ]; then
      echo "$MODESTRING failed !" >> testbed.tex
      echo "failed ! $MODESTRING failed !";
      SIM="Failed"
      EVO="Failed"
    else
      echo "Evaluation failed !" >> testbed.tex
      echo "failed ! Evaluation failed !";
      SIM="OK"
      EVO="Failed"

    fi
  else
    echo "OK !" >> testbed.tex
    echo "ok."
    SIM="OK"
    EVO="OK"

    IMGS=`ls $WORKDIR/$MEASUREMENTNUM/evaluation/ | egrep "png$|jpg$"`
    IMG_COUNT=`echo $IMGS | wc -w`

    if [ $IMG_COUNT -gt 0 ]; then

      (cd $WORKDIR/$MEASUREMENTNUM/evaluation/; for p in $IMGS; do mv $p $CURRENT_DIR/img/$NUM-$p; done)

      for p in $IMGS; do
        echo "\begin{figure}[h]" >> testbed.tex
        echo "\centering" >> testbed.tex
        echo "\includegraphics[width=0.50\textwidth]{img/$NUM-$p}" >> testbed.tex
        echo "\end{figure}" >> testbed.tex
      done
    fi

  fi
  (cd $WORKDIR; rm -rf $MEASUREMENTNUM/)
  
  echo "$NAME & $SIM & $EVO \\\\" >> summary.tex
  echo "\cline{1-3}" >> summary.tex
  
  i=`expr $i + 1`
done

echo "\end{tabular}" >> summary.tex
echo "\caption{Summary}" >> summary.tex
echo "\label{tab:measurements_parameters}" >> summary.tex
echo "\end{table}" >> summary.tex
								

echo "\end{document}" >> testbed.tex

pdflatex -halt-on-error testbed.tex > /dev/null 2>&1

if [ -f testbed.pdf ]; then
  rm -f testbed.aux testbed.log testbed.tex summary.tex summary.aux IEEEtran.*
  rm -rf img
fi
