#!/bin/bash -xe

# Add manual java path (make sure to add "/include/")
JAVA_INCLUDE_PATH=

# Building from arm directly?
ARM=FALSE

if [ -d "$JAVA_INCLUDE_PATH" ]
then
    echo "Using user selected java path: $JAVA_INCLUDE_PATH"

elif [ -d "/opt/jvm/jdk1.8.0/include/" ]
then
    JAVA_INCLUDE_PATH=/opt/jvm/jdk1.8.0/include/

elif [ -d "/usr/lib/jvm/java-1.8.0-openjdk-amd64" ]
then
    JAVA_INCLUDE_PATH=/usr/lib/jvm/java-1.8.0-openjdk-amd64/include/

elif [ -d "/usr/lib/jvm/java-1.8.0-openjdk-armhf" ]
then
    JAVA_INCLUDE_PATH=/usr/lib/jvm/java-1.8.0-openjdk-armhf/include/
    ARM=TRUE

else
    echo "No java installation found. Please install java or manually enter the include path."
    echo "sudo apt-get install openjdk-8-jdk openjdk-8-jre"
    exit 1
fi

export JAVA_INCLUDE_PATH

# Compiling on arm directly
if [ "$ARM" == "TRUE" ]
then
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
else
    mkdir -p distrib/linux64
    cd libserialport
    ./autogen.sh
    ./configure
    make clean
    make
    cd ..
    gcc main.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/  -o listSerialC
    cp listSerialC distrib/linux64/listSerialC
    gcc jnilib.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -I$JAVA_INCLUDE_PATH -I$JAVA_INCLUDE_PATH/linux/ -shared -fPIC -o liblistSerialsj.so
    cp liblistSerialsj.so distrib/linux64/

    mkdir -p distrib/linux32
    cd libserialport
    CFLAGS=-m32 ./configure
    make clean
    make
    cd ..
    gcc -m32 main.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -o listSerialC
    cp listSerialC distrib/linux32/listSerialC
    gcc -m32 jnilib.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -I$JAVA_INCLUDE_PATH -I$JAVA_INCLUDE_PATH/linux/ -shared -fPIC -o liblistSerialsj.so
    cp liblistSerialsj.so distrib/linux32

    mkdir -p distrib/arm
    cd libserialport
    ./configure --host=arm-linux-gnueabihf
    make clean
    make
    cd ..
    arm-linux-gnueabihf-gcc main.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/  -o listSerialC
    cp listSerialC distrib/arm/listSerialC
    arm-linux-gnueabihf-gcc jnilib.c libserialport/linux_termios.c libserialport/linux.c libserialport/serialport.c -Ilibserialport/ -I$JAVA_INCLUDE_PATH -I$JAVA_INCLUDE_PATH/linux/ -shared -fPIC -o liblistSerialsj.so
    cp liblistSerialsj.so distrib/arm/
fi
