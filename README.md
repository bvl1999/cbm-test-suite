# cbm-test-suite

A test suite for stress testing storage connected to CBM machines, for now C64 and C128.

Inspired by testing new storage additions to the UII+ and U64 hardware.

RUNNING THIS ON ANY PHYSICAL STORAGE MEDIUM MAY CAUSE SERIOUS WEAR TO THE MEDIUM AND DRIVE

This is a set of stress tests intended to test filesystem allocation/deallocation, correct
file size hehavior for any file size between 200 bytes and the largest which can reasonably
be loaded by your machine minus a bit of space used by the software itself (a bit less than 46k
on a c64, 62.5k on a c128). This also serves to stress test the firmware of the drive for
memory leaks or other behavior under heavy use.

Don't use this on usb sticks or floppies or even floppy drives that might not like getting
tens to hundreds of thousands of file creation, write and delete actions.



Everything using acme syntax.

'acme 64test.asm' builds the 64 version

'acme 128test.asm' builds the c128 version

That should do it for now
