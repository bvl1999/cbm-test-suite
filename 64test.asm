!src "cbm/kernal64.asm"
!src "cbm/zeropage64.asm"

workptr = strpooltmpptr                    ; needed by string/print libraries
savebase = end+1
maxpage = $d0 ; actually max page - 1

*=$0801

!to "testsuite64.prg", cbm

scratchpad=$0334                            ; for string/print libraries

!byte <end,>end,$01,$00,$9e               ; Line 1 SYS2062
!convtab pet
!tx "2062"                                  ; Address for sys start in text
!byte $00,$00,$00

*=$080d

!src "shared.asm"
end
