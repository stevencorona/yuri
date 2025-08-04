use std::env;
use std::path::PathBuf;

include!("../build_helper.rs");

fn main() {
    let root_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let common_dir = root_dir.parent().unwrap().join("common/c_src");
    let deps_dir = root_dir.parent().unwrap().join("common/c_deps");

    // Build login server C code
    let mut build = cc::Build::new();
    build
        .files(&[
            "c_src/login_server.c",
            "c_src/login_parse.c",
            "c_src/login_char.c",
        ])
        .include("c_src")
        .include(&common_dir)
        .include(&deps_dir)
        .warnings(false);
    
    // Add standard flags
    for flag in standard_flags() {
        build.flag(flag);
    }
    
    build.compile("login_server_c");

    // Find common build directory
    let target_dir = root_dir.parent().unwrap().join("target/debug/build");
    if let Some(out_dir) = find_common_out_dir(&target_dir) {
        println!("cargo:rustc-link-search=native={}", out_dir.display());
    }

    // Link with libraries
    println!("cargo:rustc-link-lib=static=common_c");
    println!("cargo:rustc-link-lib=static=deps");
    
    // Link MySQL
    link_mysql();
    
    // Link zlib
    println!("cargo:rustc-link-lib=z");
}