#!/bin/sh

LIMIT=35
i=1

cat share/main.tex > testbed.tex

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
    else
      echo "Evaluation failed !" >> testbed.tex
      echo "failed ! Evaluation failed !";
    fi
  else
    echo "OK !" >> testbed.tex
    echo "ok."
  fi
  (cd $DIR; rm -rf 1/)
  
  i=`expr $i + 1`
done

echo "\end{document}" >> testbed.tex

pdflatex testbed.tex > /dev/null 2>&1

rm -f testbed.aux testbed.log testbed.tex
