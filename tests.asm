	.include "funcs.asm"
	
	.text
	.globl main
	
main:
	
	li $t1, 0x00000000
	li $t2, 0x00040000
	
	#complex_abs_squared_integer($t3, $t1, $t2)
	
	#.macro complex_multiply(%dest_re, %dest_im, %a_re, %a_im, %b_re, %b_im)
	
	complex_multiply($t3, $t4, $t1, $t2, $t1, $t2)
	
	#srl $t3, $t3, 16
	#srl $t4, $t4, 16
	li $t1, 0