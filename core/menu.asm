; main menu

.numkeys=3                         ; number of keys, note 1st key is always 0, so this should be 1 higher than the number of menu items in actual use. 
max_dev=30                         ; highest allowed device id
min_dev=8                          ; lowest allowed device id

; nokey is different for c128 and c64 
!ifdef c128 {
    nokey = 88
} else {
    nokey = 64
}

main_menu
    lda #2
    sta pause
    lda #6
    sta $d020
    lda #0
    sta $d021
    +Print .headertext
    sec                            ; set carry to make .prind_devid register its screen coordinates
    jsr .print_devid
    lda #$9b
    jsr CHROUT
    lda #$0d
    jsr CHROUT
    jsr CHROUT
    +Print .menutext
     
.scankeys
    cli
    lda #nokey
.waitnokey                         ; wait until no key pressed before accepting new input
-
    cmp curkey
    bne .waitnokey
.waitkey
-
    lda curkey
    cmp #nokey
    beq .waitkey
    cmp #40
    bne +
    jsr .inc_devid
    jmp .scankeys
+   cmp #43
    bne +
    jsr .dec_devid
    jmp .scankeys
+
    ldx #0
.checkkey
    cmp .keytab,x                   ; regular number keys
    beq .knownkey
!ifdef c128 {
    cmp .keytab2,x                  ; numeric keypad, 128 mode only as we rely on kernal keyboard scan
    beq .knownkey
}
    inx
    cpx #.numkeys                   ; artificially limit the keys we recognize
    bne .checkkey                   ; check next key in table
    jmp .waitkey
.knownkey                           ; recognized, now check what to do
    txa
    pha
    jsr printint                    ; first print it, always nice to visually respond.
    lda #$0d
    jsr CHROUT
    pla

.option_0
    cmp #0
    bne .option_1
    lda #0
    sta ndx
    jmp do_exit

.option_1
    cmp #1
    bne .option_2
    jsr file_create_test
    jsr check_pause
    jmp main_menu

.option_2
    cmp #2
    bne .option_3
    jsr file_size_test
    jsr check_pause
    jmp main_menu

.option_3
.option_4
.option_5
.option_6
.option_7
.option_8
.option_9
.endkeyscan
    jmp main_menu

.inc_devid
    ldx devid
    inx
    cpx #max_dev+1
    beq +
    stx devid
    clc
    jsr .print_devid
+   rts

.dec_devid
    ldx devid
    dex
    cpx #min_dev-1
    beq +
    stx devid
    clc
    jsr .print_devid
+   
    rts

; print the current device id, if carry set, register display coordinates, if carry clear, print at the registered coordinates.
.print_devid
    bcc .print_devid_at
    jsr PLOT
    stx devid_xpos
    txa
    pha
    sty devid_ypos
    tya
    pha
    jmp .print_devid_doit

.print_devid_at
    sec
    jsr PLOT
    txa
    pha
    tya
    pha
    clc
    ldx devid_xpos
    ldy devid_ypos
    jsr PLOT

.print_devid_doit
    lda #$9e
    jsr CHROUT
    lda devid
    cmp #10
    bcs +
    tay
    lda #' '
    jsr CHROUT
    tya
+
    jsr printint
    pla
    tay
    pla
    tax
    clc
    jsr PLOT
    lda #$05
    jsr CHROUT
    rts

.keytab
!byte 35, 56, 59, 8, 11, 16, 19, 24, 27, 32

!ifdef c128 {
.keytab2
!byte 81, 71, 68, 79, 69, 66, 77, 70, 65, 78
}

.headertext
!byte 8,14, 147, $9e ; cls, yellow
!tx "CBM storage test suite v1.0"
!byte $0d,05,$0d
!tx "By Bart van Leeuwen"
!byte $0d,$9b,$0d ; grey
!tx "device id (+/- to change): "
!byte $9e, 0 ; yellow

.menutext
!tx "1. file create/delete test"
!byte $0d,$0d
!tx "2. test read files with increasing size"
!byte $0d,$0d
!tx "0. quit"
!byte $0d,$0d
!byte $05
!tx "your choice: "
!byte 0
