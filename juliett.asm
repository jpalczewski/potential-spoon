	.include "funcs.asm"
	.include "bmp.asm"
	.include "die.asm"
		
	.data
	# 
	#user-defined parameters
	#
	
	#files - input, output
fin:	.asciiz "/home/erxyi/Projekty/_16Z/ARKO/potential-spoon/input.bmp"	# input file
fout:	.asciiz "output.bmp"	# output file
	
	# c value
c_real:	.word	123
c_im:	.word	456
	
	# min-max
min_real: 	.word	789
min_im:		.word	123
max_real:	.word	345
max_im:		.word	789	
	
	
	.text
	
	
	.globl main
main:
	print_str(hello_string)
	
	#
	# Step 1 - loading BMP header
	#
	li $v0, 13
	la $a0, fin
	li $a1, 0
	li $a2, 0
	syscall
	move $s6, $v0
	
	#if $v0 is less than zero - something is wrong.
	bltz $s6, error_nofile
	
	#lets read first 30 bytes of file. 
	move $a0, $s6
	li $v0, 14
	la $a1, bmp_header_buffer
	li $a2, BMP_HEADER_LEN
	syscall
	
	#few checks
	bne  $v0, BMP_HEADER_LEN, error_badfile 
	blez $v0, error_badfile # reading file failed, EOF too early or header is too short. 
	
	
	lh $t0, bfType
	bne $t0, 0x4d42, error_badfile # Are we dealing with BM magic numbers?
	
	#
	# Step 2 - we possibly have good file, so let's read it into memory. 
	#
	lw $a0, bfSize
	li $v0, 9
	syscall
	
	move $t0, $v0
	
	exit(0)
	
error_nofile:
	die(ENOFILE)

error_badfile:
	die(EBADHEADER)	
	.data
	
hello_string:		.asciiz "Juliett set generator\nby jpalczewski\n"