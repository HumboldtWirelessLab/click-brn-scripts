CC = clang
CPP = clang++
CFLAGS = -Wall -Wextra -Wno-unused-parameter -g -O2
LDFLAGS = -L$(HOME)/workspace/OpenPACE/trunk/openssl/ -lcrypto -L$(HOME)/.local/lib

all: dealer.cpp
	$(CPP) $(CFLAGS) dealer.cpp -o dealer $(LDFLAGS)

valgrind:
	LD_LIBRARY_PATH=$(HOME)/workspace/OpenPACE/trunk/openssl/ valgrind --leak-check=full --track-origins=yes ./dealer

clean:
	rm -rf dealer
