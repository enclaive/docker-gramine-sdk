CFLAGS = -Wall -Wextra

.PHONY: all
all: helloworld 

helloworld: helloworld.o

helloworld.o: helloworld.c

.PHONY: check
check: all
	./helloworld > OUTPUT
	echo "Hello, world" | diff OUTPUT -
	@echo "[ Success ]"

.PHONY: entrypoint
entrypoint: all
	@if test -f /manifest/helloworld.template; then\
			echo "File exists already. Aborting.";\
	else\
		cp ./helloworld /entrypoint;\
		cp /gramine-sdk/templates/helloworld.manifest.template  /manifest;\
		echo "[ ENCLAVE installed ]";\
	fi 

.PHONY: clean
clean:
	$(RM) helloworld.o helloworld OUTPUT
	echo "[ Helloworld deleted ]"

.PHONY: distclean
distclean: clean
