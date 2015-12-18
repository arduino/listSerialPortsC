mkdir -p distrib/windows && cd libserialport && ./configure --host=i686-w64-mingw32 && make clean && make && cd .. && i686-w64-mingw32-gcc main.c libserialport/windows.c libserialport/serialport.c -Ilibserialport/ -lsetupapi -static -o listSerialC.exe && cp listSerialC.exe distrib/windows/
i686-w64-mingw32-gcc  jnilib.c libserialport/windows.c libserialport/serialport.c -lsetupapi -Ilibserialport/ -I/opt/jvm/jdk1.8.0/include/ -I/opt/jvm/jdk1.8.0/include/linux/ -shared -o listSerialsj.dll && cp listSerialsj.dll distrib/windows/

