	.include "funcs.asm"
	.include "bmp.asm"
	.include "die.asm"
	.include "colors.asm"
	.data
	# 
	#user-defined parameters
	#
	 
	#files - input, output
fin:	.asciiz "/home/erxyi/Projekty/_16Z/ARKO/potential-spoon/input_small.bmp"	# input file
fout:	.asciiz "/home/erxyi/Projekty/_16Z/ARKO/potential-spoon/output4.bmp"	# input file


#fin:	.asciiz "Z:\\Biblioteka\\Projekty\\potential-spoon\\input.bmp"
#fout:	.asciiz "Z:\\Biblioteka\\Projekty\\potential-spoon\\output.bmp"	# output file

		
	# c value
.align 4
c_x:	.word	0x00233451
c_y:	.word	0x00423131
step:	.word	0x00008cAA



#c_x:	.word	0x00233451
#c_y:	.word	0x00423131
#step:	.word	0x000F0AAA


.align 4
stored_x: .space 4
stored_y: .space 4
stored_s0: .space 4
stored_s1: .space 4

	
#min_real: 	.word	789
#min_im:		.word	123
	
	
	.text
	


#mini-dokuemntacja

#przeznaczenie rejestrów:
#s0-s7 - zmienne/bufory/rejestry trzymane w całej aplikacji
#t0-t9 - do wykonania jednej, "atomowej" operacji

#$s0 - FILE* input;
#$s1 - FILE* output;
#$s2 - char* buffer;
#$s3 - int padding;
#$s4 - int width*3
#$s5 - int height
#$s6 - 
#$s7 - 

#$t0 - 
#$t1 - 
#$t2 - 
#$t3 - 
#$t4 - 
#$t5 -
#$t6 - 
#$t7 - 

	
	
	.globl main
main:
	print_str(hello_string)
	
	#
	# Step 1 - loading BMP header
	#
	
	#let's open both files
	li $v0, 13
	la $a0, fin
	li $a1, 0
	li $a2, 0
	syscall
	move $s0, $v0
	
	li $v0, 13
	la $a0, fout
	li $a1, 1
	li $a2, 0
	syscall
	move $s1, $v0
	
	
	#if $v0 is less than zero - something is wrong.
	bltz $s0, error_nofile
	bltz $s1, error_nofile
	
	#lets read first 30 bytes of file. 
	move $a0, $s0
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
	sub $a0, $a0, BMP_HEADER_LEN # MARS didn't load from beginning, so we should consider data loaded above.
	li $v0, 9
	syscall
	move $s2, $v0 # now in $t0 is our buffer for whole file
	
	
	move $a2, $a0 # data re-use from previous syscall
	move $a1, $s2 # setting our buffer
	move $a0, $s0 # and unused file pointer
	li $v0, 14
	syscall
	
	#
	# So,we have whole file in memory. Let's rock!
	#
	
	
	# Step one - padding - multiply&branch-free solution
	
	# $t0 - biWidth
	# $t1 - 3*biWidth
	# $t2 - 3*biWidth % 4
	# $t3 - 4 - $t2
	
	lw $t0, biWidth
	sll, $t1, $t0, 1
	addu $t1, $t1, $t0
	
	and $t2, $t1, 0x03
	
	li $t3, 4
	subu $t3, $t3, $t2
	
	move $s3, $zero
	movn $s3, $t3, $t2
	move $s4, $t1
	
	lw $s5, biHeight
	
	
	#step -1: uwalnianie s0 i s1
	#sw $s0, stored_s0
	#sw $s1, stored_s1
	
	#Let start processing	
	# $t0 - offset, $t0 - buffer+offset, line counter
	#$t1 - line start
	#$t2 - line end	
	#$t2 - line counter
	#$t3 - pixel[0]
	#$t4 - pixel[1]
	#$t5 - pixel[2]
	lw  $t0, bfOffBits 
	subu $t0, $t0, BMP_HEADER_LEN
	addu $t0, $s2, $t0
	
	move $t1, $t0
	addu $t2, $t1, $s4
	
	li $t0, 0
	li $t6, 0xFF000000
	li $t7, 0xFF000000
	lw $t8, step
	move $s6, $s3
	move $s7, $s4
	push_s()
line_start:

	#Usable registers: $t6, $t7, $t8, $t9, $s6, $s7
	# julia points
	# t6 - x, t7 - y, t8 - step, t9 - n, t4, t5, s6, s7 - posrednie/kolory
	
	#x,y = rog obrazka
	# x += step przy przejsciu w lewo, x = x_begin, y+= step przy przejsciu do nastepnej linii
	# 
	#z = t6,t7 potem
	
	
	
	
	#wyrzucamy x,y z pamieci w celu odzyskania rejestrow
	
	li $t9, 255
	
	sw $t6, stored_x
	sw $t7, stored_y
	
	
	lw $t4, c_x
	lw $t5, c_y

	#complex_multiply(%dest_re, %dest_im, %a_re, %a_im, %b_re, %b_im)
	julia_loop($t6, $t7, $t4, $t5)
	
	
colors:

	move $t4, $v0
	cb($v0)
	
	lbu $t3,  ($t1) #blue
	move $t3, $v0
	sb $t3,	 ($t1)
	
	
	move $v0, $t4
	g($v0)
	lbu $t3,  1($t1) #green
	move $t3, $v0
	sb $t3,	 1($t1)
	
	move $v0, $t4
	r($v0)
	lbu $t3,  2($t1) #red
	move $t3, $v0
	sb $t3,	 2($t1)
	
	
	lw $t6, stored_x
	lw $t7, stored_y
	
	addu $t6, $t6, $t8
	
	
	addiu $t1, $t1, 3
	bne $t1, $t2, line_start

line_stop:
	pop_s()
	addu $t1, $t1, $s6 #add bmp padding
	addu $t2, $t1, $s7
	addiu $t0, $t0, 1
	
	li $t6, 0
	addu $t7, $t7, $t8 #add y padding
	
	bne $t0, $s5, line_start

	
	


processing_finished:
	pop_s()
	#Writing whole file in memory back to disk.
	li $v0, 15
	move $a0, $s1
	la $a1, bmp_header_buffer
	li $a2, BMP_HEADER_LEN
	syscall	
	
	li $v0, 15
	move $a0, $s1
	move $a1, $s2
	lw $a2, bfSize
	sub $a2, $a2 , BMP_HEADER_LEN
	syscall
	
	
	# And let's close the fh
	move $a0, $s0
	li $v0, 16
	syscall
	
	move $a0, $s1
	li $v0, 16
	syscall
	
	exit(0)
	
error_nofile:
	die(ENOFILE)

error_badfile:
	die(EBADHEADER)
		
	.data
	
hello_string:		.asciiz "Juliett set generator\nby jpalczewski\n"
