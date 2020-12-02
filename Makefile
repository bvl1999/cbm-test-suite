ASMFILES = shared.asm core/menu.asm core/startup.asm core/data.asm std/string.asm std/print.asm std/sendcmd.asm std/scratchfile.asm std/checkpause.asm tests/eoftest.asm tests/crdeltest.asm
.PHONY: all

all: testsuite64.prg testsuite128.prg

testsuite64.prg: 64test.asm cbm/zeropage64.asm cbm/kernal64.asm  $(ASMFILES)
	acme 64test.asm

testsuite128.prg: 128test.asm cbm/zeropage128.asm cbm/kernal128.asm $(ASMFILES)
	acme 128test.asm

.PHONY: clean

clean:
	rm -f testsuite*.prg

