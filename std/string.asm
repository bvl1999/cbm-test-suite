; libstring.asm
;

; all strings handled by these routines must be null-terminated, and their
; maximum length determined by the range of the index registers is 255 chars

;	strsrc = .uptr1
;	strdst = .uptr2
;	tmpval =tmpvalval
	.slen = $b1

; strlen - returns the length of a string in Y, preserves X
; (upon return, index register Y points to the terminator)

strlen	ldy #0
.lena	lda (strdst),y
	beq .lenb
	iny
	bne .lena
.lenb	rts

; strcpy - copies a string fromstrsrc tostrdst, preserves X

strcpy	ldy #0
.scpya	lda (strsrc),y
	sta (strdst),y		; the store instruction does not change the
	beq .scpyb		; Z flag and this copies the terminator too
	iny
	bne .scpya		; maximum length of the string is 255 chars
.scpyb	rts

; strncpy - copies a string up to the specified point set in 'len'

strncpy	ldy #0
.sncpya	lda (strsrc),y
	sta (strdst),y
	beq .sncpyb
	iny
	cpy .slen
	bcc .sncpya
	lda #0			; terminate the destination when cutting
	sta (strdst),y
.sncpyb	rts

; strcat - concate strsrc and strdst, ie. add strsrc to strdst - preserves nothing

strcat	
        jsr strlen		; get index to the end of thestrdst string
        tya
        clc
        adc strdst
        sta strdst
        bcc +
        inc strdst+1
+       jsr strcpy
	rts

strcmp
        jsr strlen
        sty .slen
strncmp ldy #0
-       lda (strsrc),y
        sec
        sbc (strdst),y
        beq +
        rts
+       iny
        cpy .slen
        bne -
        lda #0
        rts
