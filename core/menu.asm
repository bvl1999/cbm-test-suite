
; main menu

.numkeys=5
max_dev=30
min_dev=8

!ifdef c128 {
    nokey = 88
} else {
    nokey = 64
}

pause
!byte 0
devid_xpos
!byte 0
devid_ypos
!byte 0

main_menu
    lda #6
    sta $d020
    lda #0
    sta $d021
    +Print .headertext
    sec
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

    rts

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
    cmp #3
    bne .option_4
    jsr .inc_devid
    jmp main_menu

.option_4
    jsr .dec_devid
    jmp main_menu

.inc_devid
    ldx devid
    inx
    cpx #max_dev+1
    beq +
    stx devid
+   rts

.dec_devid
    ldx devid
    dex
    cpx #min_dev-1
    beq +
    stx devid
+   rts

.print_devid
    bcc .print_devid_at
    jsr PLOT
    stx devid_xpos
    sty devid_ypos
    jmp .print_devid_doit

.print_devid_at
    ldx devid_xpos
    ldy devid_ypos
    jsr PLOT

.print_devid_doit
    lda devid
    cmp #10
    bcc +
    tay
    lda #' '
    jsr CHROUT
    tya
+
    jsr printint
    rts

.keytab
!byte 35, 56, 59, 8, 11, 16, 19, 24, 27, 32

!ifdef c128 {
.keytab2
!byte 81, 71, 68, 79, 69, 66, 77, 70, 65, 78
}

.headertext
!byte 8,14, 147, $9e ; cls, yellow
!tx "CBM storage test suite v0.01 alpha"
!byte $0d,05,$0d
!tx "By Bart van Leeuwen in 2020"
!byte $0d,$9b,$0d ; grey
!tx "device id: "
!byte $9e, 0 ; yellow

.menutext
!tx "1. file create/delete test"
!byte $0d,$0d
!tx "2. test read files with increasing size"
!byte $0d,$0d
!tx "3. increase device id"
!byte $0d,$0d
!tx "4. decrease device id"
!byte $0d,$0d
!tx "0. quit"
!byte $0d,$0d
!byte $05
!tx "your choice: "
!byte 0
