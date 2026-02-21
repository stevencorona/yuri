use std::ffi::CString;
use std::os::raw::{c_char, c_int};

extern "C" {
    fn start_map_server(argc: c_int, argv: *const *const c_char) -> c_int;
}

fn main() {
    // Convert Rust args to C-style argc/argv
    let args: Vec<CString> = std::env::args()
        .map(|arg| CString::new(arg).expect("Failed to convert argument"))
        .collect();
    
    let argv: Vec<*const c_char> = args.iter()
        .map(|arg| arg.as_ptr())
        .collect();
    
    let argc = argv.len() as c_int;
    
    // Call the C main function
    let exit_code = unsafe {
        start_map_server(argc, argv.as_ptr())
    };
    
    std::process::exit(exit_code);
}