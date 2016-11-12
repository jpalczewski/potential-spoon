	.text 

	.macro die(%reason)
	
	#Select string related with reason code...
	li	$s0, %reason
	sll	$s1, $s0, 2
	la	$s3, error_table($s1)
	lw	$a0, ($s3)
	
	#...print it...
	li 	$v0, 4
	syscall
	
	#...and die.
	move	$a0, $s0
	li	$v0, 17
	syscall
	
	
	.end_macro



	.data
	
	.eqv ENOFILE, 0
	.eqv EBADHEADER, 1
	
nofile:		.asciiz "BMP loading failed - cannot open file"
badheader:	.asciiz "BMP loading failed - something is bad with header"
	
error_table: 	.word	nofile,badheader
