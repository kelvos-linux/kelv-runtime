#![no_std]
#![no_main]

use kelvos_rs::prelude::*;

#[kelvos_rs::entry]
fn main() -> ! {
    if task::spawn().is_err() {
        task::idle_forever();
    }

    task::idle_forever()
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    task::idle_forever()
}