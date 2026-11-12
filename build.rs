use kelvos_shared_ring::layout::{PAGE_SIZE, USER_IMAGE_ADDRESS, USER_IMAGE_END};

fn main() {
    println!("cargo:rerun-if-changed=linker.ld");
    if std::env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("none") {
        for (symbol, value) in [
            ("PAGE_SIZE", PAGE_SIZE),
            ("USER_IMAGE_ADDRESS", USER_IMAGE_ADDRESS),
            ("USER_IMAGE_END", USER_IMAGE_END),
        ] {
            println!("cargo:rustc-link-arg=--defsym={symbol}={value:#x}");
        }
        println!(
            "cargo:rustc-link-arg=-T{}/linker.ld",
            std::env::var("CARGO_MANIFEST_DIR").unwrap()
        );
    }
}
