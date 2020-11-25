!cpu 6510
!initmem $00

tmpval=$fa
strsrc=$fb
strdst=$fd

; only macros and no code here!
!src "6502/std.a" ; acme

; startup code first.. should be at a specific location.
!src "core/startup.asm"

; anything else, order shouldn't matter
; some lib stuff
!src "std/print.asm"
!src "std/string.asm"
!src "std/checkpause.asm"

; ui
!src "core/menu.asm"

; our tests
!src "tests/eoftest.asm"
!src "tests/crdeltest.asm"
