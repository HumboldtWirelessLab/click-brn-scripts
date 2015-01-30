#!/bin/bash

for file in *.eps
do
	echo "$file"
	ps2pdf -dEPSCrop $file ${file/.eps/.pdf}
done
