#!/bin/bash -xe

mkdir -p distrib/linux64
cd libserialport
./autogen.sh
./configure
make clean
make
cd ..
gcc main.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/  -o listSerialC
cp listSerialC distrib/linux64/listSerialC
gcc jnilib.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -I/usr/lib/jvm/java-1.8.0-openjdk-amd64/include/ -I/usr/lib/jvm/java-1.8.0-openjdk-amd64/include/linux/ -shared -fPIC -o liblistSerialsj.so
cp liblistSerialsj.so distrib/linux64/

mkdir -p distrib/linux32
cd libserialport
CFLAGS=-m32 ./configure
make clean
make
cd ..
gcc -m32 main.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -o listSerialC
cp listSerialC distrib/linux32/listSerialC
gcc -m32 jnilib.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -I/usr/lib/jvm/java-1.8.0-openjdk-amd64/include/ -I/usr/lib/jvm/java-1.8.0-openjdk-amd64/include/linux/ -shared -fPIC -o liblistSerialsj.so
cp liblistSerialsj.so distrib/linux32

