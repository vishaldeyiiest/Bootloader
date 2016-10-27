nasm -f bin bootsector.asm -o boot.bin
gcc -ffreestanding -c ./test.c -o test.o -m32
ld -o test.bin -Ttext 0x1000 test.o --oformat binary -melf_i386
cat boot.bin test.bin > OS_Image
qemu-system-i386 OS_Image
rm OS_Image boot.bin test.bin test.o

