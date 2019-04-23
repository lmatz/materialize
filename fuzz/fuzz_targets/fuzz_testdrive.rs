#![no_main]
#[macro_use]
extern crate libfuzzer_sys;

fuzz_target!(|data: &[u8]| {
    if let Ok(string) = std::str::from_utf8(data) {
        match testdrive::run_string("<fuzzer>", &string) {
            Ok(()) | Err(testdrive::Error::Input { .. }) | Err(testdrive::Error::Usage) => (),
            Err(error @ testdrive::Error::General { .. }) => panic!("{}", error),
        }
    };
});