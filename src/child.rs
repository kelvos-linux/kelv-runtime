#![no_std]
#![no_main]

use kelvos_rs::prelude::*;

#[kelvos_rs::entry]
fn main() -> ! {
    task::exit_with(42)
}

#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! {
    task::exit_with(1)
}
