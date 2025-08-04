mod network;

use libc::c_char;
use std::ffi::CStr;
use std::ffi::CString;

#[no_mangle]
pub extern "C" fn rust_generate_hashvalues(name: *const c_char, mut buffer: *mut c_char) {
    let c_name = unsafe {
        assert!(!name.is_null());

        CStr::from_ptr(name)
    };
    let hashed = network::crypt::generate_hash(c_name.to_str().unwrap());
    let c_hash_ptr = CString::new(hashed).unwrap();
    buffer = c_hash_ptr.into_raw();
}
