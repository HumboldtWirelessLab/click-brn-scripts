#!/bin/zsh

# Search for EPS-Picture (beginning at the current directory)
# convert EPS-PICTURE from UTF-8 to ISO_8859-15-format
# convert EPS-Picture to PDF-File
result_directory="new"
mkdir -p $result_directory
for x in *.eps; 
    do
        z=${x/.eps/_2.eps}
        h=${x/.eps/_3.eps}
        sed 's/Fenstergr\\303\\266\\303\\237e/Fenstergröße/g;s/\\303\\274bertragende Bytes/Übertragende Bytes/g' $x > $result_directory/$h
        iconv -f UTF-8 -t ISO_8859-15 $result_directory/$h > $result_directory/$z 
        epstopdf $result_directory/$z
        y=${z/.eps/.pdf}
        pdfcrop -margins '5 5 5 5' $result_directory/$y
        rm -f $result_directory/$z
        rm -f $result_directory/$h
        rm -f $result_directory/$y
    done

