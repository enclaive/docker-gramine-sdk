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

.PHONY: clean
clean:
	$(RM) helloworld.o helloworld OUTPUT

.PHONY: distclean
distclean: clean
