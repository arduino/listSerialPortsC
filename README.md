_Simple environment to test libserialport in a single build machine fashion_

Prerequisites:
* An [osxcross](https://github.com/tpoechtrager/osxcross) installation
* An updated mingw32 environment

TLTR:
```bash
# Install java8
sudo apt-get install openjdk-8-jdk openjdk-8-jre

dpkg --add-architecture i386
apt-get install build-essential gcc-multilib g++-multilib mingw-w64 xz-utils libxml2-dev clang patch git gcc-4.8-arm-linux-gnueabihf g++-4.8-arm-linux-gnueabihf autoconf libtool linux-libc-dev:i386 gcc-arm-linux-gnueabihf zip
#setup osxcross + add binaries to PATH
git clone https://github.com/facchinm/listSerialPortsC --recursive
./pack_and_release.sh
```

TODO:
* Add a golang wrapper
