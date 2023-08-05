use std::ffi::CStr;
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn tanuki(s: *const c_char) -> u32 {
    if s.is_null() {
        eprintln!("Null pointer provided!");
        return 0;
    }
    unsafe {
        let raw = CStr::from_ptr(s);
        match raw.to_str() {
            Ok(valid_str) => {
                let bpe = match tiktoken_rs::p50k_base() {
                    Ok(bpe) => bpe,
                    Err(e) => {
                        eprintln!("Failed to create BPE: {:?}", e);
                        return 0;
                    }
                };
                let tokens = bpe.encode_with_special_tokens(valid_str);
                tokens.len() as u32
            },
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                0
            }
        }
    }
}