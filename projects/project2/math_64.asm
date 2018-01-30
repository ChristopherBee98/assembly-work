	;; Project 2: convert c code in nasm code, Austin Bailey
	;; don't set rax to 0 for floating point numbers, (see lecture 4)
	;; store values into arrays before performing operations
	;; for cross: check registers/values to make sure no values are being carried over in loops

	        extern printf

	section .data
dfmt1:		db 	"dot n=%ld", 10, 0
cfmt1:		db 	"cross n=%ld", 10, 0
dfmt2:		db 	"x[1]=%e", 10, 0
sum:		dq   	0.0
zero:		dq	0.0
i:		dq	0
m:		dq	0
j:		dq	0
k:		dq	0.0
sign:		dq	1.0

	section .bss
n:		resq 	1		; value of n
x:		resq 	1		; address of x array
y:		resq 	1		; address of y array
z:		resq 	1		; address of z array

	section .text
	
	global dot		; dot(n,x,y)
dot:
	push	rbp	; save rbp

	mov	[n],rdi		; save value of n
	mov	[x],rsi		; save address of x array
	mov	[y],rdx		; save address of y array

	mov	rdi, dfmt1
	mov	rsi, [n]        ; print value of n
	mov	rax, 0
	call	printf

	;;  compute dot product and put function result in  xmm0 (complete)

	mov	rax,[x]		; address of x[0] in rax
	mov	rbx,[y]	 	; address of y[0] in rbx

	;;  this needs to loop [n] times
loop:
	cmp	rdi,[n]
	je	next
	;; put thing here
	fld	qword [rax+rdi*8]	; value of x[0] on FP stack
	fmul	qword [rbx+rdi*8]  	; add value of y[0] to FP stack
	fadd	qword [sum]	; accumulate sum
	fstp    qword [sum] 	; save sum	
	mov	rdi,[i]
	inc	rdi
	mov	[i],rdi
	mov	r9,[i]
	cmp	r9,[n]		; i<n
	jl	loop
next:	
	movq	xmm0, qword [sum] ; return value of sum
	pop	rbp
	ret		; return
	;;  end dot

	global cross		; cross(n,x,y,z)
cross:
	push	rbp	; save rbp

	mov	[n],rdi		; save address of n
	mov	[x],rsi		; save address of x
	mov	[y],rdx		; save address of y
	mov	[z],rcx		; save address of z

	mov	rdi, cfmt1
	mov	rsi, [n]	; print value of n
	mov	rax, 0
	call	printf

	;;  compute cross product and put result in z array (check logic)
	fld	qword [zero]
	mov	rcx, [z]
	fstp	qword [rcx]

	mov	rax,[x]
	mov	rbx,[y]
	;; rax has base address of x
	;; rbx has base address of y
	;; rcx has base address of z
	;; loop -------------------------
	mov	r8,[m]		;loop m=0 .. m<n
	mov	r9,[j]		;inner loop j=0 .. j<n
	mov	r10,[k]		; computed if ...
loopm:
	mov	r8,[m]
	cmp	r8,[n]
	je	finish
	;; maybe z[m] = 0.0?
	fld	qword [zero]
	fstp	qword [rcx+8*r8]
	mov	r9,0
	mov	r11,0
	mov	[j],r11
loopj:
	mov	r10,0
	mov	[k],r10
	add	r10,[j]	;k = j + m
	add	r10,[m]
	mov	[k],r10

	cmp	r10,[n] 	;if (k >= n) k = k - n;
	jge	subN
norm:	
	fld     qword [rax+r9*8] 	; x[j]
	fmul    qword [rbx+r10*8] ;x[j]*y[k]
	fadd    qword [rcx+r8*8]  ;z[m]+x[j]*y[k]
	fstp    qword [rcx+r8*8]  ;z[m] = z[m]+x[j]*y[k]
	
	mov	r11,[j]
	inc	r11
	mov	[j],r11
	mov	r11,0
	mov	r9,[j]
	cmp	r9,[n]
	jl	loopj

	fld	qword [rcx+r8*8] ;z[m] = sign*z[m]
	fmul	qword [sign]
	fstp	qword [rcx+r8*8]
	
	fld	qword [sign]
	fchs
	fstp	qword [sign] 	; sign = -sign

	mov	r11,[m]
	inc	r11
	mov	[m],r11
	mov	r11,0
	jmp	loopm
	;; loop -------------------------
subN:
	sub	r10,[n] 	;look here for possible logic problem
	mov	[k],r10
	jmp	norm
finish:	
	pop	rbp
	ret		; return
	;;  end cross