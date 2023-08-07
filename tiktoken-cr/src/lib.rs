use std::convert::TryInto;
use std::ffi::CStr;
use std::os::raw::c_char;
use tiktoken_rs;
use tiktoken_rs::CoreBPE;

#[no_mangle]
pub extern "C" fn r50k_base_raw() -> *mut CoreBPE {
    let bpe = tiktoken_rs::r50k_base();
    let corebpe = bpe.unwrap();
    let boxed = Box::new(corebpe);
    Box::into_raw(boxed)
}

#[no_mangle]
pub extern "C" fn p50k_base_raw() -> *mut CoreBPE {
    let bpe = tiktoken_rs::p50k_base();
    let corebpe = bpe.unwrap();
    let boxed = Box::new(corebpe);
    Box::into_raw(boxed)
}

#[no_mangle]
pub extern "C" fn p50k_edit_raw() -> *mut CoreBPE {
    let bpe = tiktoken_rs::p50k_edit();
    let corebpe = bpe.unwrap();
    let boxed = Box::new(corebpe);
    Box::into_raw(boxed)
}

#[no_mangle]
pub extern "C" fn cl100k_base_raw() -> *mut CoreBPE {
    let bpe = tiktoken_rs::cl100k_base();
    let corebpe = bpe.unwrap();
    let boxed = Box::new(corebpe);
    Box::into_raw(boxed)
}

#[no_mangle]
pub extern "C" fn destroy_corebpe_raw(ptr: *mut CoreBPE) {
    if ptr.is_null() {
        return;
    }
    unsafe {
        let _ = Box::from_raw(ptr);
    }
}

#[repr(C)]
pub struct FunctionCall2 {
    pub name: *const c_char,
    pub arguments: *const c_char,
}

#[repr(C)]
pub struct ChatCompletionRequestMessage2 {
    pub role: *const c_char,
    pub content: *const c_char,
    pub name: *const c_char,
    pub function_call: *const FunctionCall2,
}

fn get_string_from_c_char(ptr: *const c_char) -> Result<String, std::str::Utf8Error> {
    let c_str = unsafe { CStr::from_ptr(ptr) };
    let str_slice = c_str.to_str()?;
    Ok(str_slice.to_string())
}

fn c_str_to_string(ptr: *const c_char) -> Option<String> {
    if ptr.is_null() {
        return None;
    }

    let c_str = match get_string_from_c_char(ptr) {
        Ok(str) => str,
        Err(_) => {
            eprintln!("Invalid UTF-8 sequence provided!");
            return None;
        }
    };

    Some(c_str)
}

#[no_mangle]
pub extern "C" fn get_completion_max_tokens_raw(
    model: *const c_char,
    prompt: *const c_char,
) -> i32 {
    if model.is_null() {
        eprintln!("Null pointer provided!");
        return -1;
    }
    if prompt.is_null() {
        eprintln!("Null pointer provided!");
        return -2;
    }
    let model = unsafe {
        let raw = CStr::from_ptr(model);
        match raw.to_str() {
            Ok(valid_str) => valid_str,
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                return -3;
            }
        }
    };
    let prompt = unsafe {
        let raw = CStr::from_ptr(prompt);
        match raw.to_str() {
            Ok(valid_str) => valid_str,
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                return -4;
            }
        }
    };
    match tiktoken_rs::get_completion_max_tokens(model, prompt) {
        Ok(max_tokens) => {
            if max_tokens > i32::MAX.try_into().unwrap() {
                eprintln!("Max tokens exceeds i32 range!");
                return -6;
            }
            max_tokens as i32
        }
        Err(_) => {
            eprintln!("Failed to get completion max tokens!");
            return -5;
        }
    }
}

#[no_mangle]
pub extern "C" fn num_tokens_from_messages_raw(
    model: *const c_char,
    num_messages: u32,
    messages: *const ChatCompletionRequestMessage2,
) -> i32 {
    if model.is_null() {
        eprintln!("Null pointer provided!");
        return -1;
    }
    if messages.is_null() {
        eprintln!("Null pointer provided!");
        return -2;
    }
    let model = unsafe {
        let raw = CStr::from_ptr(model);
        match raw.to_str() {
            Ok(valid_str) => valid_str,
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                return -3;
            }
        }
    };
    let messages = unsafe {
        let slice = std::slice::from_raw_parts(messages, num_messages as usize);
        let mut messages_vec = Vec::with_capacity(num_messages as usize);
        for message in slice {
            let role = c_str_to_string(message.role.clone()).unwrap_or_default();
            let content = c_str_to_string(message.content.clone());
            let name = c_str_to_string(message.name.clone());
            let function_call = if !message.function_call.is_null() {
                let fun_call = message.function_call;
                let fun_name = c_str_to_string((*fun_call).name).unwrap_or_default();
                let fun_args = c_str_to_string((*fun_call).arguments).unwrap_or_default();
                Some(tiktoken_rs::FunctionCall {
                    name: fun_name,
                    arguments: fun_args,
                })
            } else {
                None
            };
            messages_vec.push(tiktoken_rs::ChatCompletionRequestMessage {
                role: role,
                content: content,
                name: name,
                function_call: function_call,
            });
        }
        messages_vec
    };
    match tiktoken_rs::num_tokens_from_messages(model, &messages) {
        Ok(num_tokens) => {
            if num_tokens > i32::MAX.try_into().unwrap() {
                eprintln!("Num tokens exceeds i32 range!");
                return -5;
            }
            num_tokens as i32
        }
        Err(_) => {
            eprintln!("Failed to get num tokens!");
            return -4;
        }
    }
}

#[no_mangle]
pub extern "C" fn get_chat_completion_max_tokens_raw(
    model: *const c_char,
    num_messages: u32,
    messages: *const ChatCompletionRequestMessage2,
) -> i32 {
    if model.is_null() {
        eprintln!("Null pointer provided!");
        return -1;
    }
    if messages.is_null() {
        eprintln!("Null pointer provided!");
        return -2;
    }
    let model = unsafe {
        let raw = CStr::from_ptr(model);
        match raw.to_str() {
            Ok(valid_str) => valid_str,
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                return -3;
            }
        }
    };
    let messages = unsafe {
        let slice = std::slice::from_raw_parts(messages, num_messages as usize);
        let mut messages_vec = Vec::with_capacity(num_messages as usize);
        for message in slice {
            let role = c_str_to_string(message.role.clone()).unwrap_or_default();
            let content = c_str_to_string(message.content.clone());
            let name = c_str_to_string(message.name.clone());
            let function_call = if !message.function_call.is_null() {
                let fun_call = message.function_call;
                let fun_name = c_str_to_string((*fun_call).name).unwrap_or_default();
                let fun_args = c_str_to_string((*fun_call).arguments).unwrap_or_default();
                Some(tiktoken_rs::FunctionCall {
                    name: fun_name,
                    arguments: fun_args,
                })
            } else {
                None
            };
            messages_vec.push(tiktoken_rs::ChatCompletionRequestMessage {
                role: role,
                content: content,
                name: name,
                function_call: function_call,
            });
        }
        messages_vec
    };
    match tiktoken_rs::get_chat_completion_max_tokens(model, &messages) {
        Ok(max_tokens) => {
            if max_tokens > i32::MAX.try_into().unwrap() {
                eprintln!("Max tokens exceeds i32 range!");
                return -5;
            }
            max_tokens as i32
        }
        Err(_) => {
            eprintln!("Failed to get max tokens!");
            return -4;
        }
    }
}

#[no_mangle]
pub extern "C" fn get_bpe_from_model_raw(model: *const c_char) -> *mut CoreBPE {
    if model.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    let model = unsafe {
        let raw = CStr::from_ptr(model);
        match raw.to_str() {
            Ok(valid_str) => valid_str,
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                return std::ptr::null_mut();
            }
        }
    };
    let bpe = tiktoken_rs::get_bpe_from_model(model);
    match bpe {
        Ok(bpe) => {
            let boxed = Box::new(bpe);
            Box::into_raw(boxed)
        }
        Err(_) => {
            eprintln!("Failed to get BPE from model!");
            std::ptr::null_mut()
        }
    }
}

//

#[no_mangle]
pub extern "C" fn corebpe_encode_ordinary_raw(
    ptr: *mut CoreBPE,
    text: *const c_char,
    num_tokens: *mut u32,
) -> *mut u64 {
    if ptr.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    if text.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    if num_tokens.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    let text = unsafe {
        let raw = CStr::from_ptr(text);
        match raw.to_str() {
            Ok(valid_str) => valid_str,
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                return std::ptr::null_mut();
            }
        }
    };
    let corebpe = unsafe { &mut *ptr };
    let encoded = corebpe.encode_ordinary(text);
    if encoded.len() > u32::MAX as usize {
        eprintln!("Encoded exceeds u32 range!");
        return std::ptr::null_mut();
    }
    unsafe { *num_tokens = encoded.len() as u32 };
    let boxed = encoded.into_boxed_slice();
    let ptr = Box::into_raw(boxed);
    ptr as *mut u64
}

#[no_mangle]
pub extern "C" fn corebpe_encode_with_special_tokens_raw(
    ptr: *mut CoreBPE,
    text: *const c_char,
    num_tokens: *mut u32,
) -> *mut u64 {
    if ptr.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    if text.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    if num_tokens.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    let text = unsafe {
        let raw = CStr::from_ptr(text);
        match raw.to_str() {
            Ok(valid_str) => valid_str,
            Err(_) => {
                eprintln!("Invalid UTF-8 sequence provided!");
                return std::ptr::null_mut();
            }
        }
    };
    let corebpe = unsafe { &mut *ptr };
    let encoded = corebpe.encode_with_special_tokens(text);
    if encoded.len() > u32::MAX as usize {
        eprintln!("Encoded exceeds u32 range!");
        return std::ptr::null_mut();
    }
    unsafe { *num_tokens = encoded.len() as u32 };
    let boxed = encoded.into_boxed_slice();
    let ptr = Box::into_raw(boxed);
    ptr as *mut u64
}

#[no_mangle]
pub extern "C" fn corebpe_decode_raw(
    ptr: *mut CoreBPE,
    tokens: *const u64,
    num_tokens: u32,
) -> *mut c_char {
    if ptr.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    if tokens.is_null() {
        eprintln!("Null pointer provided!");
        return std::ptr::null_mut();
    }
    let tokens = unsafe { std::slice::from_raw_parts(tokens, num_tokens as usize) };
    let tokens: Vec<usize> = tokens.iter().map(|&x| x as usize).collect();

    let corebpe = unsafe { &mut *ptr };
    let decoded = corebpe.decode(tokens);
    let decoded = match decoded {
        Ok(decoded) => decoded,
        Err(_) => {
            eprintln!("Failed to decode!");
            return std::ptr::null_mut();
        }
    };
    let c_str = match std::ffi::CString::new(decoded) {
        Ok(c_str) => c_str,
        Err(_) => {
            eprintln!("Failed to convert to CString!");
            return std::ptr::null_mut();
        }
    };
    let ptr = c_str.into_raw();
    ptr
}