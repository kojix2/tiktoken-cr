use std::convert::TryInto;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use tiktoken_rs;

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
    pub function_call: FunctionCall2,
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
            let fun_name = c_str_to_string(message.function_call.name.clone()).unwrap_or_default();
            let fun_args =
                c_str_to_string(message.function_call.arguments.clone()).unwrap_or_default();
            messages_vec.push(tiktoken_rs::ChatCompletionRequestMessage {
                role: role,
                content: content,
                name: name,
                function_call: Some(tiktoken_rs::FunctionCall {
                    name: fun_name,
                    arguments: fun_args,
                }),
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
            let fun_name = c_str_to_string(message.function_call.name.clone()).unwrap_or_default();
            let fun_args =
                c_str_to_string(message.function_call.arguments.clone()).unwrap_or_default();
            messages_vec.push(tiktoken_rs::ChatCompletionRequestMessage {
                role: role,
                content: content,
                name: name,
                function_call: Some(tiktoken_rs::FunctionCall {
                    name: fun_name,
                    arguments: fun_args,
                }),
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
