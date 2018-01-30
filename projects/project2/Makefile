all: math_64.out



math_64.out: math_64.asm # using printf                                         

	nasm -g -f elf64 math_64.asm

	gcc -g3 -m64 -o math_64 test_math_64.c math_64.o

	./math_64 > math_64.out

	cat math_64.out