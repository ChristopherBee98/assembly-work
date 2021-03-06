	;; plotc.asm, Austin Bailey
	section .data
af:	dq	1.0, 0.0, -0.5 ; coefficients of cosine polynomial, a_0 first
	dq	0.0, 0.041667, 0.0, -0.001389, 0.0, 0.000025
XF:	dq	0.0	; computed  compute  Y = cos(XF)
Y:	dq	0.0	; computed
N:	dq	8	; power of polynomial
X0:	dq	-3.14159 ; start XF
DX0:	dq	0.15708	 ; increment for XF  ncol-1  times
one:	dq      1.0
nten:	dq      -10.0
twenty  dq      20.0
a10     db      10,0 	; need address of a10 for linefeed
ncol:	dq      41
nrow:	dq      21
spc:	db      ' '
star:	db      '*'
	section .bss
a2:	resb    21*41		;two dimensional array of bytes
i:	resq    1		;row subscript
j:	resq    1		;col subscript
k:	resq    1		;row subscript
	section .text
	global	_start
_start:
	push	rbp
	;; part 1 (Complete)
	;; iloop
	;; 	jloop
	;; 		blank=space a2 array
	;; 	end jloop
	;; end iloop
	;;  clear a2 to space
	mov 	rax,0		; i=0  for(i=0;
	mov	[i],rax
loopi:
	mov	rax,[i]         ; reload i, rax may be used
	mov 	rbx,0		; j=0  for(j=0;
	mov	[j],rbx
loopj:
	mov	rax,[i]         ; reload i, rax may be used
	mov	rbx,[j]         ; reload j, rbx may be used
	imul 	rax,[ncol]	; i*ncol
	add  	rax, rbx	; i*ncol + j
	mov 	dl, [spc]	; need just character, byte
	mov 	[a2+rax],dl	; store space

	mov	rbx,[j]
	inc 	rbx		; j++
	mov	[j],rbx
	cmp 	rbx,[ncol]      ; j<ncol
	jne 	loopj

	mov	rax,[i]
	inc 	rax		; i++
	mov	[i],rax
	cmp	rax,[nrow]	; i<nrow
	jne 	loopi
	;;  end clear a2 to space

	;;  j = 0;
	;;  XF = X0;  fld qword [X0]  fstp qword [Xf]

	;; part2 (finish commented section at bottom of part2) (done)
	;; XF = 0.0
	;; jloop
	;; 	compute cosine and put * in a2 array
	;; end jloop
jloop:	
	fld     qword [X0]
	fstp    qword [XF]
	mov     rax, 0
	mov     [j], rax ; j = 0
cos:	mov	rcx,[N]	 ; loop iteration count initialization, n
	fld	qword [af+8*rcx] ; accumulate value here, get coefficient a_n
h5loop:	fmul	qword [XF] ; * XF
	fadd	qword [af+8*rcx-8] ; + aa_n-i
	loop	h5loop		   ; decrement rcx, jump on non zero
	fstp	qword [Y]	   ; store Y
	;; FINISH ---------------------------------------------------------------------------------
	
	;;  k = 20.0 + (Y+1.0)*(-10.0)  fistp qword [k]
	;;  rax  gets  k * ncol + j
	;;  put "*" in dl, then dl into [a2+rax
	;; still unfinished (k = 20.0 + (Y+1.0)*(-10.0))
	fld	qword [Y]
	fadd	qword [one]
	fmul	qword [nten]
	fadd	qword [twenty]
	fistp	qword [k]
	mov	rax,[k]
	imul	rax,[ncol]
	add	rax,[j]
	mov	dl,[star]
	mov	[a2+rax],dl

	;;  XF = XF + DX0;
	;;  j = j+1;
	;;  if(j != ncol) go to cos  jloop
	fld	qword [XF]
	fadd	qword [DX0]
	fstp	qword [XF]
	mov	rax,[j]
	inc	rax
	mov	[j],rax
	cmp	rax,[ncol]
	jl	cos
	
	
	;; THIS -----------------------------------------------------------------------------------
	
	;; part 3 (copy part 1 but replace blank space with print) (complete? needs testing) (done)
	;; iloop
	;; 	jloop
	;; 		print a2 array
	;; 	end jloop
	;; end iloop
	mov	rax,0
	mov	[i],rax
loopi2:
	mov	rax,[i]         ; reload i, rax may be used
	mov 	rbx,0		; j=0  for(j=0;
	mov	[j],rbx
loopj2:

	mov     rax, [i] ; a2+i*ncol+j  is byte
	imul    rax, [ncol]
	add     rax, [j]
	add     rax, a2
	mov     rsi, rax ; address of character to print
	mov  	rax, 1		 ; system call 1 is write
	mov  	rdi, 1		 ; file handle 1 is stdout
	mov	rdx, 1		 ; number of bytes
	syscall			 ; invoke operating system to do the write

	mov	rbx,[j]
	inc 	rbx		; j++
	mov	[j],rbx
	cmp 	rbx,[ncol]      ; j<ncol
	jne 	loopj2

	mov	rax,[i]
	inc 	rax		; i++
	mov	[i],rax
	cmp	rax,[nrow]	; i<nrow
	jne 	loopi2
	;;  end clear a2 to space

	;;  j = 0;
	;;  XF = X0;  fld qword [X0]  fstp qword [Xf]

	pop	rbp
	mov	rax,60
	mov	rdi,0
	syscall			; done, exit
	;; end of plotc.asm