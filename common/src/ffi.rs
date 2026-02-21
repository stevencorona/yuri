use std::ffi::{CStr, CString};
use std::os::raw::{c_char, c_int, c_uchar};

extern "C" {
    // You'll need to declare generate_hashvalues too if it's in a separate file
    fn populate_table(name: *const c_char, table: *mut c_char, tablelen: c_int) -> *mut c_char;
    fn generate_key2(
        packet: *mut c_uchar,
        table: *mut c_char,
        keyout: *mut c_char,
        fromclient: c_int,
    ) -> *mut c_char;
}

/// Temporary - can remove once I'm sure they work exactly the same
pub fn generate_key2_wrapper(
    packet: &[u8],
    table: &[u8; 1024], // or &[u8] if variable size
    from_client: bool,
) -> [u8; 9] {
    let mut keyout = [0u8; 10]; // 9 bytes + null terminator

    unsafe {
        // Need mutable copies for C
        let mut packet_copy = packet.to_vec();
        let mut table_copy = table.to_vec();

        let result = generate_key2(
            packet_copy.as_mut_ptr(),
            table_copy.as_mut_ptr() as *mut c_char,
            keyout.as_mut_ptr() as *mut c_char,
            from_client as c_int,
        );

        if result.is_null() {
            panic!("generate_key2 returned null");
        }
    }

    // Return without the null terminator
    let mut result = [0u8; 9];
    result.copy_from_slice(&keyout[..9]);
    result
}

/// Temporary - can remove once I'm sure they work exactly the same
pub fn lookup_table_c(key: &str) -> [u8; 1024] {
    let mut result = [0u8; 1024];

    let c_key = CString::new(key).expect("CString conversion failed");

    unsafe {
        // C expects a char buffer, we need to give it space for null-terminated hex strings
        let mut c_buffer = vec![0u8; 1025]; // Extra byte for null terminator

        let ret = populate_table(
            c_key.as_ptr(),
            c_buffer.as_mut_ptr() as *mut c_char,
            1025 as c_int,
        );

        if ret.is_null() {
            panic!("populate_table returned null");
        }

        // Convert the hex string back to bytes
        let hex_str = CStr::from_ptr(ret).to_str().unwrap();

        result.copy_from_slice(hex_str.as_bytes());
    }

    result
}
