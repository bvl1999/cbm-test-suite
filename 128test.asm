c128=1

!src "cbm/kernal128.asm"
!src "cbm/zeropage128.asm"

*= $1c01

!to "testsuite128.prg", cbm

scratchpad=$0b00                            ; for string/print libraries

!byte <.end,>.end,$01,$00,$9e               ; Line 1 SYS7182
!convtab pet
!tx "7182"                                  ; Address for sys start in text
!byte $00,$00,$00
*=$1c0d

!src "shared.asm"
