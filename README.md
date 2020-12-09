# cbm-test-suite

A test suite for stress testing storage connected to CBM machines, for now C64 and C128.

Inspired by testing new storage additions to the UII+ and U64 hardware.

RUNNING THIS ON ANY PHYSICAL STORAGE MEDIUM MAY CAUSE SERIOUS WEAR TO THE MEDIUM AND DRIVE

This is a set of stress tests intended to test filesystem allocation/deallocation, correct
file size hehavior and contents.  This also serves to stress test the firmware of the drive for
memory leaks or other behavior under heavy use.

- create/delete test (small file) to test repeated alloc/de-alloc

- create files with sizes between 200 bytes and a machine dependent maximum (about 46k on C64
  and 63k on a C128)

Don't use this on usb sticks or floppies or even floppy drives that might not like getting
tens to hundreds of thousands of file creation, write and delete actions.

The tests can easily be extended and/or modified.

Everything using acme assembler syntax and you will need an installed version of acme to build

https://sourceforge.net/projects/acme-crossass/

Also, you'll want to have gnu make installed.

To build:

'make'

or

'make archive'

Output will be in the target subdirectory.

If you do not have gnu make...

'acme -f cbm -o target/testsuite64.prg --cpu 6502 systems/64test.asm'
'acme -f cbm -o target/testsuite128.prg --cpu 6502 systems/128test.asm'


License:

This software is copyright 2020 by Bart van Leeuwen and comes with a simple 2 clause BSD style
license:

- use this for whatever purpose you like

- do not claim to have written this

Enjoy your storage stress testing!
