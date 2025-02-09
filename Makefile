# enable this for armv7 builds, lazily using iPhone SDK
#CFLAGS = -I /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include -arch armv7 -Os
CFLAGS = -std=c99 -Os -Wall -Wextra -Wno-unknown-pragmas -Werror-implicit-function-declaration -Werror -Wno-unused-parameter -Wdeclaration-after-statement -Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes -Iinclude
CC=gcc
all: cntest

test: cntest
	(cd test; env MallocStackLogging=true ../cntest) >new.out
	-diff new.out test/expected.out

cntest: src/cbor.h include/cn-cbor/cn-cbor.h src/cn-cbor.c src/cn-error.c src/cn-get.c test/test.c
	$(CC) $(CFLAGS) src/cn-cbor.c src/cn-error.c src/cn-get.c test/test.c -o cntest

size: cn-cbor.o
	size cn-cbor.o
	size -m cn-cbor.o

cn-cbor.o: src/cn-cbor.c include/cn-cbor/cn-cbor.h src/cbor.h
	clang $(CFLAGS) -c src/cn-cbor.c

cn-cbor-play.zip: Makefile src/cbor.h src/cn-cbor.c include/cn-cbor/cn-cbor.h test/expected.out test/test.c
	zip $@ $^

clean:
	$(RM) cntest *.o new.out cn-cbor-play.zip
