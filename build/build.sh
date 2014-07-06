VER=`cat ../version.txt`
DATE=`date "+%Y-%m"`

# assemble the source files

rm -rf src; mkdir -p src; cd src
node ../doTool.js ../../preface.asciidoc >book.asciidoc <<< "{
  \"version\": \"$VER\",
  \"date\": \"$DATE\"
}"
for p in `cat ../../parts.txt`; do
  cat "../$p/content.asciidoc" >>book.asciidoc
done
cat ../../appendix.asciidoc >>book.asciidoc
cd -

# generate the files
cd src
rm -rf book.xml
asciidoc -b docbook book.asciidoc
cd -

rm -rf $VER; mkdir -p $VER; cd $VER
xsltproc --nonet ../docbook-xsl/chunked.xsl ../src/book.xml
cp -rv ../stylesheets/* .
cp -rv ../images .
cd -

# generate the outside symlink
cd ..
rm -rf current
ln -s build/$VER current
cd -
