#https://www.solarianprogrammer.com/2013/02/28/mandelbrot-set-cpp-11/

	.text
	
	.macro multiply_and_recover(%a, %b)
	mult %a, %b	
	mflo $s1
	mfhi $s2
	sll $s2, $s2, 8
	srl $s1, $s1, 24
	or  %a, $s1, $s2
	.end_macro
	
	.macro r(%t)
		li $s3, 0x01000000
		li $s4, 0x09000000
		sll %t, %t, 24
		srl %t, %t, 8
		move $s5, %t
		
		sub %t $s3, %t
		multiply_and_recover(%t, $s4)
		multiply_and_recover(%t, $s5)
		multiply_and_recover(%t, $s5)
		multiply_and_recover(%t, $s5)
		sll %t, %t, 8
		srl %t, %t, 24
	.end_macro
	
	.macro g(%t)
		li $s3, 0x01000000
		li $s4, 0x0F000000
		sll %t, %t, 24
		srl %t, %t, 8
		move $s5, %t
		
		subu $s3, $s3, %t
		multiply_and_recover(%t, $s3)
		multiply_and_recover(%t, $s3)
		multiply_and_recover(%t, $s4)
		multiply_and_recover(%t, $s5)
		sll %t, %t, 8
		srl %t, %t, 24
	.end_macro
	
	.macro cb(%t)
		li $s3, 0x01000000
		li $s4, 0x08800000
		sll %t, %t, 24
		srl %t, %t, 8
		move $s5, %t
		
		sub $s3, $s3, %t
		multiply_and_recover(%t, $s3)
		multiply_and_recover(%t, $s3)
		multiply_and_recover(%t, $s3)
		multiply_and_recover(%t, $s4)
		sll %t, %t, 8
		srl %t, %t, 24
	.end_macro
