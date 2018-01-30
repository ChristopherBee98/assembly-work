	;;  math_64.asm  a direct coding of  math_64.c  (included as comments)
	;; // math_64.c  compute dot and cross product of two vectors
	;; double dot(long int n, double x[], double y[])
	;; {
	;;   double sum = 0.0;
	;;   long int i;
	;;   for(i=0; i<n; i++) sum = x[i]*y[i];
	;;   return sum;
	;; } // end dot
	;;
	;; void cross(long int n, double x[], double y[], double z[])
	;; {
	;;   double sign = 1.0;
	;;   long int m, j, k;
	;;   for(m=0; m<n; m++) // answer
	;;   {
	;;     z[m] = 0.0;
	;;     for(j=0; j<n; j++) // column
	;;     {
	;;       k = j+m;
	;;       if(k>=n) k = k-n;
	;;       z[m] = z[m] + x[j]*y[k];
	;;     } // end j
	;;     z[m] = sign*z[m];
	;;     sign = -sign;
	;;   } // end m
	;; } // end cross

	        extern printf

	section .data
dfmt1:		db "dot n=%ld", 10, 0
cfmt1:		db "cross n=%ld", 10, 0
dfmt2:		db "x[1]=%e", 10, 0
sum:		dq   0.0

	section .bss
n:		resq 1		; value of n
x:		resq 1		; address of x array
y:		resq 1		; address of y array
z:		resq 1		; address of z array

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

	mov	rdi, dfmt2
	mov	rbx, [x]	; address of x[0]
	movq	xmm0, qword [rbx+8] ; address of x[1]
	mov	rax, 1
	call	printf

	;;  compute dot product and put function result in  xmm0

	mov	rax,[x]		; address of x[0] in rax
	mov	rbx,[y]	 	; address of y[0] in rbx

	;;  this needs to loop [n] times
	fld	qword [rax]	; value of x[0] on FP stack
	fmul	qword [rbx]  	; add value of y[0] to FP stack
	fadd	qword [sum]	; accumulate sum
	fstp    qword [sum] 	; save sum


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

	;;  compute cross product and put result in z array

	        pop	rbp
	        ret		; return
	;;  end cross