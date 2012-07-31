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

if [ $LATEX -eq 1 ]; then
    SUMMARY=summary.tex
    TESTBED=testbed.tex
else
    SUMMARY=summary.log
    TESTBED=summary.log
fi

LIMIT=$LIMIT
i=$START

TOPDIR=$PWD
CURRENT_DIR=$PWD

if [ $LATEX -eq 1 ]; then
    cat $DIR/share/main.tex > testbed.tex
    cp $DIR/share/IEEEtran* .
fi

if [ "x$MODE" = "xSIMULATION" ]; then
  MODESTRING="Simulation"
fi

if [ $LATEX -eq 1 ]; then
    echo "\input{summary}" >> testbed.tex

    echo "\section{Summary}" > summary.tex

    echo "\begin{table}[h]" >> summary.tex
    echo "\centering" >> summary.tex
    if [ "x$VALGRIND" = "x1" ]; then
      echo "\begin{tabular}{p{.35\textwidth}p{.15\textwidth}p{.15\textwidth}p{.15\textwidth}p{.10\textwidth}}" >> summary.tex
      echo "\colheadbegin \textbf{Scenario} & \textbf{$MODESTRING} & \textbf{Evaluation} & \textbf{Memory Leak} & \textbf{Time}" >> summary.tex
    else
      echo "\begin{tabular}{p{.40\textwidth}p{.20\textwidth}p{.20\textwidth}p{.10\textwidth}}" >> summary.tex
      echo "\colheadbegin \textbf{Scenario} & \textbf{$MODESTRING} & \textbf{Evaluation} & \textbf{Time}" >> summary.tex
    fi
    echo "\colheadend" >> summary.tex

    mkdir -p img
fi

while [ $i -le $LIMIT ]; do
  MEASUREMENTNUM=$RANDOM
  NUM=`printf "%03d\n" $i`
  WORKDIR=`ls -w 1 | awk '{print $1}' | grep "$NUM-"`
  NAME=`echo $WORKDIR | sed "s#$NUM-##g" | sed "s#_# #g"`
  DESCRIPTIONFILE=`(cd $WORKDIR;ls *.des | awk '{print $1}')`
  echo -n "Test $WORKDIR "
  if [ $LATEX -eq 1 ]; then
      echo "\section{$NAME}" >> testbed.tex
      echo "\subsection{Output}" >> testbed.tex
  fi


  if [ "x$MODE" = "xSIMULATION" ]; then
    (cd $WORKDIR; EVAL_LOG_OUT=3 run_sim.sh ns $DESCRIPTIONFILE $MEASUREMENTNUM) 1> /dev/null 3>> $TESTBED
    RESULT=$?
  else
    if [ "x$MODE" = "xMEASUREMENT" ]; then
      (cd $WORKDIR; EVAL_LOG_OUT=3 RUNMODE=REBOOT run_measurement.sh $DESCRIPTIONFILE $MEASUREMENTNUM ) >> $TESTBED 3>&1
      RESULT=$?
    else
      RESULT=1
    fi
  fi

  if [ $LATEX -eq 1 ]; then
      echo "\subsection{Result}" >> testbed.tex
  fi

  if [ $RESULT -ne 0 ]; then
    if [ $RESULT -eq 1 ]; then
      echo "$MODESTRING failed !" >> $TESTBED
      echo "failed ! $MODESTRING failed !";
      SIM="Failed"
      EVO="Failed"
    else
      echo "Evaluation failed !" >> $TESTBED
      echo "failed ! Evaluation failed !";
      SIM="OK"
      EVO="Failed"
    fi
  else
    echo "OK !" >> testbed.tex
    echo "ok."
    SIM="OK"
    EVO="OK"

    if [ $LATEX -eq 1 ]; then
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

    if [ "x$VALGRIND" = "x1" ]; then
      LEAKBYTES=`(cd $WORKDIR/$MEASUREMENTNUM/; cat valgrind.log | grep -A 4 "LEAK SUMMARY" | grep "definitely lost" | awk '{print $4}' | sed "s#,##g" )`
      if [ $LEAKBYTES -eq 0 ]; then
        MEMORYLEAK=NO
      else
        MEMORYLEAK=YES
      fi
    fi

  fi

  if [ -f $WORKDIR/$MEASUREMENTNUM/time.stats ]; then
    TIMESTATS=`cat $WORKDIR/$MEASUREMENTNUM/time.stats`
  else
    TIMESTATS="00:00.00"
  fi

  (cd $WORKDIR; rm -rf $MEASUREMENTNUM/)



if [ "x$VALGRIND" = "x1" ]; then
  echo "$NAME & $SIM & $EVO & $MEMORYLEAK & $TIMESTATS \\\\" >> $SUMMARY
  LINEEND=5
else
  echo "$NAME & $SIM & $EVO & $TIMESTATS \\\\" >> $SUMMARY
  LINEEND=4
fi
  echo "\cline{1-$LINEEND}" >> $SUMMARY

  i=`expr $i + 1`
done

if [ $LATEX -eq 1 ]; then
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
fi
