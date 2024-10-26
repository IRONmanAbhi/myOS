GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386
objects = loader.o kernel.o

%.o : %.cpp
	g++ $(GPPPARAMS) -o $@ -c $<

%.o : %.s
	as $(ASPARAMS) -o $@ $<

mykernel.bin : linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

install : mykernel.bin
	sudo cp $< /boot/mykernel.bin

mykernel.iso : mykernel.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp $< iso/boot
	cp grub.cfg iso/boot/grub
	grub-mkrescue -o $@ iso
	rm -rf iso