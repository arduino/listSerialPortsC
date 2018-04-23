#!/bin/bash -xe

JAVA_INCLUDE_PATH=/usr/lib/jvm/java-8-openjdk-amd64/include/
ARCH=x86_64-w64-mingw32
CC=$ARCH-gcc
STRIP=$ARCH-strip

mkdir -p distrib/$ARCH/
cd libserialport
./autogen.sh
./configure --host=$ARCH
make clean
make
cd ..
$CC main.c -Llibserialport/.libs/ -Ilibserialport/ -lserialport -lsetupapi -static -o listSerialC.exe
cp listSerialC.exe distrib/$ARCH/
$CC -D_JNI_IMPLEMENTATION_ -Wl,--kill-at jnilib.c libserialport/.libs/libserialport.a -lsetupapi -Ilibserialport/ -I$JAVA_INCLUDE_PATH -Iwin32_jni -shared -o listSerialsj.dll
$STRIP listSerialsj.dll
cp listSerialsj.dll distrib/$ARCH/
