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
    . = USER_IMAGE_ADDRESS;
    .text :
    {
        KEEP(*(.text._start))
        *(.text .text.* .ltext .ltext.*)
    } :text
    .rodata ALIGN(PAGE_SIZE) :
    {
        *(.rodata .rodata.* .lrodata .lrodata.*)
    } :rodata
    .data ALIGN(PAGE_SIZE) :
    {
        *(.data .data.* .ldata .ldata.*)
        *(.got .got.*)
    } :data
    .bss ALIGN(PAGE_SIZE) (NOLOAD) :
    {
        *(COMMON)
        *(.bss .bss.* .lbss .lbss.*)
    } :data

    ASSERT(. <= USER_IMAGE_END, "userspace ELF exceeds the configured image window")

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
