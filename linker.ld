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
        *(.text .text.* .ltext .ltext.*)
    } :text
    .rodata ALIGN(4096) :
    {
        *(.rodata .rodata.* .lrodata .lrodata.*)
    } :rodata
    .data ALIGN(4096) :
    {
        *(.data .data.* .ldata .ldata.*)
        *(.got .got.*)
    } :data
    .bss ALIGN(4096) (NOLOAD) :
    {
        *(COMMON)
        *(.bss .bss.* .lbss .lbss.*)
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
