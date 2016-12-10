	.text

	#exits with %return_value
	.macro exit (%return_value)
	li $a0, %return_value
	li $v0, 17
	syscall
	.end_macro

	#prints string with address %str
	.macro print_str(%str)
	li $v0, 4
	la $a0, %str
	syscall
	.end_macro
	
	.macro pop_s()
	lw $s1, s1r
	lw $s2, s2r
	lw $s3, s3r
	lw $s4, s4r
	lw $s5, s5r
	lw $s6, s6r
	.end_macro
	
	.macro push_s()
	
	sw $s1, s1r
	sw $s2, s2r
	sw $s3, s3r
	sw $s4, s4r
	sw $s5, s5r
	sw $s6, s6r
	
	.end_macro
	
	
	.macro complex_square(%a, %b)
	#Dokumenta
	move $s1, %a
	mult %a, %a
	msub %b, %b
	
	mfhi $s5
	mflo $s6
	and $s5, 0xFFFF
	sll $s5, $s5, 16
	srl $s6, $s6, 16
	or %a, $s5, $s6
	
	mult $s1, %b
	mfhi $s5
	mflo $s6
	and $s5, 0xFFFF
	sll $s5, $s5, 16
	srl $s6, $s6, 16
	or %b, $s5, $s6
	
	.end_macro
	
	.macro complex_square_and_add(%a, %b, %rec, %imc)
	#Dokumenta
	li $s4, 0x01000000 # by by multiplying c by one we can add it in hi&lo.
	move $s3, %a
	mult %a, %a
	msub %b, %b
	madd $s4, %rec
	
	mflo $s1
	mfhi $s2
	sll $s2, $s2, 8
	srl $s1, $s1, 24
	or  %a, $s1, $s2
	
	mult $s3, %b
	madd $s4, %imc
	mflo $s1
	mfhi $s2
	sll $s2, $s2, 8
	srl $s1, $s1, 24
	or  %b, $s1, $s2
	sll, %b, %b, 1
	
	.end_macro
	
	.macro complex_abs_squared_integer(%dest, %re, %im)
	mult %re, %re
	madd %im, %im
	
	mflo $s1
	mfhi $s2
	sll $s2, $s2, 8
	srl $s1, $s1, 24
	or  %dest, $s1, $s2
	srl %dest, %dest, 24
	.end_macro
	
	
	
	.macro julia_loop(%a, %b, %rec, %imz)
	li $v0, 255
	complex_abs_squared_integer($a1, %a, %b)
	bge $a1, 100, jl_end
		
jl_start:
	complex_square_and_add(%a, %b, %rec, %imz)
	complex_abs_squared_integer($a1, %a, %b)
	bge $a1, 100, jl_end
	sub $v0, $v0, 5
	bgt $v0, 5, jl_start		
		
		
jl_end:	
	.end_macro
	
	.macro complex_multiply(%dest_re, %dest_im, %a_re, %a_im, %b_re, %b_im)
	
	move $s1, %a_re
	move $s2, %a_im
	move $s3, %b_re
	move $s4, %b_im
	
	mult $s1, $s3
	msub $s2, $s4
	mfhi $s5
	mflo $s6
	and $s5, 0xFFFF
	sll $s5, $s5, 16
	srl $s6, $s6, 16
	or %dest_re, $s5, $s6
	
	mult $s1, $s4
	madd $s2, $s3
	mfhi $s5
	mflo $s6
	and $s5, 0xFFFF
	sll $s5, $s5, 16
	srl $s6, $s6, 16
	or %dest_im, $s5, $s6
	
	.end_macro
	
	.data
	
hello_world:	.asciiz 	"Hello, world!"

.align 4
s1r:		.space 4
s2r:		.space 4
s3r:		.space 4
s4r:		.space 4
s5r:		.space 4
s6r:		.space 4
s7r:		.space 4


