#!/bin/sh


if [ "x$1" != "xclean" ]; then
  if [ -f $PWD/FILES ]; then
    for f in `cat $PWD/FILES`; do
      ../000-components/bin/build.sh $f
      if [ $? != 0 ]; then
        echo "Error: $f"
        exit 1
      fi      
    done
  else
    for i in `ls .`; do
      if [ -f $i/FILES ]; then
        for f in `cat $i/FILES`; do
          (cd $i; ../000-components/bin/build.sh $f)
          if [ $? != 0 ]; then
	    echo "Error: $i $f"
            exit 1
          fi      
        done
      fi
    done
  fi
else
  for i in `ls .`; do
    if [ -f $i/FILES ]; then
      for f in `cat $i/FILES`; do
        FILEOUTNAME=`echo $f | sed -e "s#\.# #g" | awk '{print $1"_out."$2}'`
        (cd $i; rm -f $FILEOUTNAME)
      done
      (cd $i; rm -f *.nam *.tr output.log)
    fi
  done
fi
      
exit 0
