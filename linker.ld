OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(_start)

PHDRS
{
    text PT_LOAD FLAGS(5);
    rodata PT_LOAD FLAGS(4);
    data PT_LOAD FLAGS(6);
}

SECTIONS
{
    . = 0x100000000;
    .text :
    {
        KEEP(*(.text._start))
        *(.text .text.*)
    } :text
    .rodata ALIGN(16) :
    {
        *(.rodata .rodata.*)
    } :rodata
    .data ALIGN(16) :
    {
        *(.data .data.*)
    } :data
    .bss ALIGN(16) (NOLOAD) :
    {
        *(COMMON)
        *(.bss .bss.*)
    } :data

    /DISCARD/ :
    {
        *(.eh_frame*)
        *(.comment)
        *(.note*)
        *(.dynamic)
        *(.dynsym)
        *(.dynstr)
        *(.gnu.hash)
        *(.hash)
        *(.interp)
    }
}
