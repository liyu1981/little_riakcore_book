NAME="book-multi"
VER="0.0.1"

# generate the files
rm -rf $NAME.xml
asciidoc -b docbook $NAME.txt
rm -rf $VER; mkdir -p $VER; cd $VER
xsltproc --nonet ../docbook-xsl/chunked.xsl ../$NAME.xml
cp -rv ../stylesheets/* .
cp -rv ../images .
cd -

# generate the outside symlink
cd ..
rm -rf current
ln -s build/$VER current
cd -
