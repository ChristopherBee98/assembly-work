	;;   ------------------------------------------------------------------------
	;;   hellos_64.asm
	;;   Writes "Hello, World" to the console using only system calls.
	;;   Runs on 64-bit Linux only.
	;;   To assemble and run: using single Linux command
	;;
	;;   nasm -f elf64 hellos_64.asm && ld hello_64s.o && ./a.out
	;;
	;;   -------------------------------------------------------------------------

	global  _start        	; standard ld main program

	section .data	      	; data section
msg:		db "Hello World",10 ; the string to print, newline 10
len:		equ $-msg	    ; "$" means "here"
	;;  len is a value, not an address

	section .text
_start:
;;;   write(1, msg, 13)         equivalent system command
	mov  	rax, 1	      	; system call 1 is write
	mov  	rdi, 1	      	; file handle 1 is stdout
	mov  	rsi, msg      	; address of string to output
	mov	rdx, len      	; number of bytes
	syscall		      	; invoke operating system to do the write

;;;   exit(0)                   equivalent system command
	mov     eax, 60	      	; system call 60 is exit
	xor     rdi, rdi      	; exit code 0
	syscall		      	; invoke operating system to exit
	