#!/bin/sh

LIMIT=28
i=28

cat share/main.tex > testbed.tex

cp share/IEEEtran* .

echo "\input{summary}" >> testbed.tex

echo "\section{Summary}" > summary.tex

echo "\begin{table}[h]" >> summary.tex
echo "\centering" >> summary.tex
echo "\begin{tabular}{p{.55\textwidth}p{.20\textwidth}p{.20\textwidth}}" >> summary.tex
echo "\colheadbegin \textbf{Scenario} & \textbf{Simulation} & \textbf{Evaluation}" >> summary.tex
echo "\colheadend" >> summary.tex

mkdir -p img

while [ $i -le $LIMIT ]; do
  NUM=`printf "%03d\n" $i`
  DIR=`ls -l | awk '{print $8}' | grep "$NUM-"`
  NAME=`echo $DIR | sed "s#$NUM-##g" | sed "s#_# #g"`
  echo -n "Test $DIR "
  echo "\section{$NAME}" >> testbed.tex
  echo "\subsection{Output}" >> testbed.tex

  (cd $DIR; EVAL_LOG_OUT=3 run_sim.sh ) 1> /dev/null 3>> testbed.tex
  RESULT=$?
  
  echo "\subsection{Result}" >> testbed.tex
  
  if [ $RESULT -ne 0 ]; then 
    if [ $RESULT -eq 1 ]; then
      echo "Simulation failed !" >> testbed.tex
      echo "failed ! Simulation failed !";
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
      IMGS=`ls $DIR/1/evaluation/ | egrep "png$|jpg$"`
      IMG_COUNT=`echo $IMGS | wc -w`
      
      (cd $DIR/1/evaluation/; mv $IMGS ../../../img)
      
      if [ $IMG_COUNT -gt 0 ]; then
        for p in $IMGS; do
          echo "\begin{figure}[p]" >> testbed.tex
          echo "\centering" >> testbed.tex
          echo "\includegraphics[width=0.50\textwidth]{img/$p}" >> testbed.tex
          echo "\end{figure}" >> testbed.tex
	done
      fi

  fi
  (cd $DIR; rm -rf 1/)
  
  echo "$NAME & $SIM & $EVO \\\\" >> summary.tex
  echo "\cline{1-3}" >> summary.tex
  
  i=`expr $i + 1`
done

echo "\end{tabular}" >> summary.tex
echo "\caption{Summary}" >> summary.tex
echo "\label{tab:measurements_parameters}" >> summary.tex
echo "\end{table}" >> summary.tex
								

echo "\end{document}" >> testbed.tex

pdflatex testbed.tex > /dev/null 2>&1

rm -f testbed.aux testbed.log testbed.tex summary.tex summary.aux

rm -f IEEEtran.*

rm -rf img
