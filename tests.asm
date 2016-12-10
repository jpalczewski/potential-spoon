	.include "funcs.asm"
	
	.text
	.globl main
	
main:
	
	li $t1, 0x00000000
	li $t2, 0x00000000
	li $t3, 0x00020000
	li $t4, 0x00020000
	#complex_abs_squared_integer($t3, $t1, $t2)
	
	#.macro complex_multiply(%dest_re, %dest_im, %a_re, %a_im, %b_re, %b_im)
	
	#complex_multiply($t3, $t4, $t1, $t2, $t1, $t2)
	#complex_square_and_add($t1, $t2, $t3, $t3)
	julia_loop($t1, $t2, $t3, $t4)
	#srl $t3, $t3, 16
	#srl $t4, $t4, 16
	li $0, 0
