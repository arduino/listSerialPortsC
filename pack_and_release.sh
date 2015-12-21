VERSION=$1
./compile_win.sh
./compile_linux.sh
./compile_mac.sh

mv distrib liblistSerials
zip -r liblistSerials-$VERSION.zip  liblistSerials/

rm -rf liblistSerials
