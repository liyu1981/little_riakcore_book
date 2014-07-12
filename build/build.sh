VER=`cat ../version.txt`
DATE=`date "+%Y-%m"`
CWD=`pwd`
SRCROOT=$CWD/..
TOOLS=$CWD/tools

if [[ "$OSTYPE" == "darwin"* ]]; then
  # fix the xsltproc can not find resource issue in OSX
  export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"
fi

# check tools first
cd tools
if [ -d "node_modules/jsdom" ]; then
  echo "tools should have been inited."
else
  npm install
  echo "tools now have been inited."
fi
cd -

# assemble the source files

rm -rf src; mkdir -p src; cd src
node $TOOLS/doTool.js $SRCROOT/cover.asciidoc >book.asciidoc <<< "{
  \"version\": \"$VER\",
  \"date\": \"$DATE\"
}"
for p in `cat $SRCROOT/parts.txt`; do
  cat "$SRCROOT/$p/content.asciidoc" >>book.asciidoc
done
cat $SRCROOT/appendix.asciidoc >>book.asciidoc
cd -

# generate the files
cd src
rm -rf book.xml
asciidoc -b docbook book.asciidoc
cd -

rm -rf $VER; mkdir -p $VER; cd $VER
xsltproc --nonet $CWD/docbook-xsl/chunked.xsl ../src/book.xml
cp -rv ../stylesheets/* .
cp -rv ../images .
cd -

# now format the doc again with my love :)
# e.g., fix the code highlighting part
cd $VER
files=`ls *.html`
for f in $files; do
  echo -n "formating" $f "... "
  node $TOOLS/format.js $f >$f.fixed
  rm $f;mv $f.fixed $f
  echo "done."
done
cd -

# generate the outside symlink
cd ..
rm -rf current
ln -s build/$VER current
cd -
