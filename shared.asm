; testsuite 64/128
; by Bart van Leeuwen, 2020
;


!cpu 6510
!initmem $00

tmpval=$fa                               ; used by string and print libraries
strsrc=$fb                               ; used by string/print libraries and various file related functions
strdst=$fd                               ; same same.
cmdbuf=$0200                             ; disk cmds, abuse basic parsing buffer

!src <6502/std.a>                        ; provided by acme, make sure to point your ACME install at the acme lib files.

; start of our code, only macros and labels allowed above this line!

!src "core/startup.asm"                  ; startup code, must come first
!src "core/data.asm"                     ; some data we care about.. keep close to start so we can include the remainder of the binary in data save/read tests

; anything else, order shouldn't matter

!src "std/print.asm"                     ; print library, print strings, 8 and 16 bit ints, and hex (8bit). 
!src "std/string.asm"                    ; some usefull string functions
!src "std/checkpause.asm"                ; wait a fraction (0), a few secs (1) or till space bar pressed (2)
!src "std/prng.asm"                      ; lfsr for generating somewhat pseudo random 8bit values (must be reproducable with a known seed for rel file tests)
!src "std/init_data.asm"                 ; fill free ram with junk for sequential read verification
!src "std/sendcmd.asm"                   ; send a dos command to the device in devid, uses file#15
!src "std/scratchfile.asm"               ; scratch file pointed at by x/y (low/high) and a (length)
!src "std/open.asm"                      ; open various types of disk files, expects SETLFS being called beforehand (and make sure to also call SETBNK on C128)

; below is where you should add your own tests
!src "core/menu.asm"                     ; menu 'system'

!src "tests/eoftest.asm"                 ; test for proper end of file behavior and file content for files with ever growing sizes (max based on ram limit)
!src "tests/crdeltest.asm"               ; repeatedly create/delete a file (65536 times)
