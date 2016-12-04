.data

.eqv BMP_HEADER_LEN 30

#without align: it works
#with align: it theoretticaly should be independent and works too

.align 4
align:   .space 2
bmp_header_buffer:
bfType:		.space 2
bfSize:		.space 4
bfReserved1:	.space 2
bfReserved2:	.space 2
bfOffBits:	.space 4
biSize:		.space 4
biWidth:	.space 4
biHeight:	.space 4
biPlanes:	.space 2
biBitCount:	.space 2
