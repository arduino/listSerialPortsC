Simple environment to test libserialport in a single build machine fashion

Prerequisites:
* An [osxcross](https://github.com/tpoechtrager/osxcross) installation
* An updated mingw32 environment

TLTR:
```bash
apt-get install build-essential gcc-multilib g++-multilib mingw-w64 xz-utils libxml2-dev clang patch git
#setup osxcross + add binaries to PATH
#wget https://releases.linaro.org/15.06/components/toolchain/gcc-linaro/4.9/gcc-linaro-4.9-2015.06.tar.xz
#tar xvf gcc-linaro-4.9-2015.06.tar.xz
#add ARM binaries to PATH
git clone https://github.com/facchinm/listSerialPortsC --recursive
./pack_and_release.sh

TODO:
* Add a golang wrapper
