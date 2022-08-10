mkdir output
ca65 -g header.asm  -o output/header.o -v
ld65 -C N163.cfg --dbgfile output/fish.dbg output/header.o -o output/fish.nes -v