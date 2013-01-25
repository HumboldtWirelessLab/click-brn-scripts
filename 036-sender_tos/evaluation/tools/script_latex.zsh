#!/bin/zsh
f_start="\\\\bgroup"
f_end="\\\\egroup"

for x in **/*crop*; do
    y="\\\\includegraphics[scale=0.4]{$x}"
    c="\\\\captionof{figure}{${x/\/*.pdf/}}"
    print $f_start >> backoff_picture.tex 
    print $y >> backoff_picture.tex 
    print $c >> backoff_picture.tex 
    print $f_end >> backoff_picture.tex 
done
pdflatex backoff.tex
