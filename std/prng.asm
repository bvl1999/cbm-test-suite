; A simple linear feedback shift register for generating pseudo random
; 8 bit numbers
; uses X, leaves Y alone, returns generated number in A
; seed is in $fd

.seed = $fd

prng
	ldx #8
	lda .seed+0
-
	asl
	rol .seed+1
	bcc +
	eor #$39
+
	dex
	bne -
	sta .seed+0
	cmp #0
	rts

