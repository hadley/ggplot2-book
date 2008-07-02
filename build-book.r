l(plyr)
l(decumar)
tex <- dir("\\.tex$")

l_ply(tex, overwrite_file)


/Applications/TextMate.app/Contents/SharedSupport/Bundles/Latex.tmbundle/Support/bin/latexmk.pl -pdf -f [^_]*.tex 

cp *.pdf public
cp *.r public