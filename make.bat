mkdir output
ca65 -g header.asm  -o output/header.o
ld65 -C nrom_256.cfg --dbgfile output/fish.dbg output/header.o -o output/fish.nes  
pause