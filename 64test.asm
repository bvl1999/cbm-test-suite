!cpu 6510
!initmem $00

!src "std/macros.asm"
!src "6502/std.a"
!src "cbm/kernal64.asm"
!src "cbm/zeropage64.asm"

workptr = strpooltmpptr                    ; needed by string/print libraries

*=$0801

!to "eoftest64.prg", cbm

scratchpad=$0334                            ; for string/print libraries

!byte <.end,>.end,$01,$00,$9e               ; Line 1 SYS2062
!convtab pet
!tx "2062"                                  ; Address for sys start in text
!byte $00,$00,$00

*=$080d

!src "tests/eoftest.asm"
!src "std/print.asm"
!src "std/string.asm"

