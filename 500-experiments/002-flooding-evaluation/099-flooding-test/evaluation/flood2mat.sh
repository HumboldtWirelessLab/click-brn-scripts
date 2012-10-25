xsltproc flood2mat.xslt $1 | sed -e 's/[a-zA-Z]*//g' | sed -e 's/,/\t/g'
