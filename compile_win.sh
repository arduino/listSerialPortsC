mkdir -p distrib/windows && cd libserialport && ./configure --host=i686-w64-mingw32 && make clean && make && cd .. && i686-w64-mingw32-gcc main.c -Llibserialport/.libs/ -Ilibserialport/ -lserialport -lsetupapi -static -o listSerialC.exe && cp listSerialC.exe distrib/windows/
i686-w64-mingw32-gcc -D_JNI_IMPLEMENTATION_ -Wl,--kill-at jnilib.c libserialport/.libs/libserialport.a -lsetupapi -Ilibserialport/ -I/opt/jvm/jdk1.8.0/include/ -I/opt/jvm/jdk1.8.0/include/win32/ -shared -o listSerialsj.dll && cp listSerialsj.dll distrib/windows/

