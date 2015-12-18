cd libserialport && ./configure && make clean && make && cd .. && gcc main.c -Ilibserialport/ -Llibserialport/.libs/ -lserialport -static -o listSerialC && cp listSerialC distrib/linux/listSerialC_64
