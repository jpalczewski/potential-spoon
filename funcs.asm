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


	.data
	
hello_world:	.asciiz 	"Hello, world!"
