#![no_std]
#![no_main]

use core::arch::{asm, global_asm};
use core::sync::atomic::Ordering;
use kelvos_shared_ring::{
    Completion, SharedRing, Submission, OP_SPAWN, SPAWN_STACK_TOP, USER_IMAGE_ADDRESS,
    USER_RING_ADDRESS,
};

global_asm!(
    ".global _start",
    ".type _start,@function",
    "_start:",
    "call user_main",
    "1:",
    "pause",
    "jmp 1b",
);

#[unsafe(no_mangle)]
extern "C" fn user_main() -> ! {
    let ring = unsafe { &*(USER_RING_ADDRESS as *const SharedRing) };
    let tail = ring.sq_tail.load(Ordering::Relaxed);

    if !ring.producer_has_space(tail) {
        stop();
    }

    unsafe {
        ring.write_submission(
            tail,
            Submission {
                opcode: OP_SPAWN,
                flags: 0,
                entry_point: USER_IMAGE_ADDRESS,
                stack_top: SPAWN_STACK_TOP,
            },
        );
    }
    ring.sq_tail.store(tail.wrapping_add(1), Ordering::Release);

    unsafe {
        asm!("int 0x80", in("rax") 1u64, options(nostack));
    }

    let head = ring.cq_head.load(Ordering::Relaxed);
    if head == ring.cq_tail.load(Ordering::Acquire) {
        stop();
    }

    let completion: Completion = unsafe { ring.read_completion(head) };
    ring.cq_head.store(head.wrapping_add(1), Ordering::Release);
    if completion.result < 0 || completion.user_data != tail as u64 {
        stop();
    }

    loop {
        unsafe { asm!("pause", options(nomem, nostack, preserves_flags)) };
    }
}

fn stop() -> ! {
    loop {
        unsafe { asm!("pause", options(nomem, nostack, preserves_flags)) };
    }
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    stop()
}
