#!/bin/bash -xe

mkdir -p distrib/arm
cd libserialport
./autogen.sh
./configure
make clean
make
cd ..
gcc main.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/  -o listSerialC
cp listSerialC distrib/arm/listSerialC
gcc jnilib.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -I/usr/lib/jvm/java-1.8.0-openjdk-armhf/include/ -I/usr/lib/jvm/java-1.8.0-openjdk-armhf/include/linux/ -shared -fPIC -o liblistSerialsj.so
cp liblistSerialsj.so distrib/arm/
