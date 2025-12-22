C_FLAGS=-fsanitize=address
main: parser.c
	gcc -Wall -Wextra -pedantic -ggdb parser.c -o main

run: main
	./main ../../assignments/02-ice-cream-moore/tmp/fsm_info.txt

gdb: main
	gdb --args main ../../assignments/02-ice-cream-moore/tmp/fsm_info.txt

