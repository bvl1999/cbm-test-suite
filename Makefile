ASMFILES = core/shared.asm core/menu.asm core/startup.asm core/data.asm std/string.asm std/print.asm std/sendcmd.asm std/scratchfile.asm std/checkpause.asm std/prng.asm std/init_data.asm std/open.asm tests/eoftest.asm tests/crdeltest.asm
ACMEFLAGS = -f cbm --initmem 0 --maxdepth 16 -v2 --cpu 6502
TARGET = target/testsuite64.prg target/testsuite128.prg

all: $(TARGET)

archive: target/cbmtestsuite.zip

target/cbmtestsuite.zip: $(TARGET)
	cd target; rm cbmtestsuite.zip; zip cbmtestsuite.zip testsuite*.prg

c64: target/testsuite64.prg

c128: target/testsuite128.prg 

target/testsuite64.prg: systems/64test.asm cbm/zeropage64.asm cbm/kernal64.asm     $(ASMFILES)
	acme $(ACMEFLAGS) -o target/testsuite64.prg systems/64test.asm

target/testsuite128.prg: systems/128test.asm cbm/zeropage128.asm cbm/kernal128.asm $(ASMFILES)
	acme $(ACMEFLAGS) -o target/testsuite128.prg systems/128test.asm

clean:
	rm -f target/testsuite*.prg

