#![no_std]
#![no_main]

use kelvos_rs::prelude::*;

#[kelvos_rs::entry]
fn main() -> ! {
    let child = task::spawn().expect("launch child");
    assert_eq!(task::wait_child(child), Ok(task::ExitStatus::Exited(42)));
    task::idle_forever()
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    task::exit_with(1)
}
