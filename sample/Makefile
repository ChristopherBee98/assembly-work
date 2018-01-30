# Makefile_nasm   for  nasm  .asm   64 bit files
all: hello_64.out

hello_64.out: hello_64.asm # using printf
	nasm -f elf64 -l hello_64.lst  hello_64.asm
	gcc -m64 -o hello_64  hello_64.o
	./hello_64 > hello_64.out
	cat hello_64.out


# add to  all:  name.out  of output file  for name.asm
# add group hello_64.out ...  changing name  "hello_64" to new name
# be sure to use "tab" in front of nasm, gcc, etc
