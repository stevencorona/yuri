use std::env;
use std::path::PathBuf;

fn main() {
    let root_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let common_dir = root_dir.parent().unwrap().join("common/c_src");
    let deps_dir = root_dir.parent().unwrap().join("c_deps");
    let yuri_lib_dir = root_dir.parent().unwrap().join("target/debug");
    
    // Build char server C code
    cc::Build::new()
        .files(&[
            "c_src/char_server.c",
            "c_src/char_db.c",
            "c_src/char_login.c",
            "c_src/char_map.c",
        ])
        .include("c_src")
        .include(&common_dir)
        .include(&deps_dir)
        .flag("-std=gnu17")
        .flag("-DFD_SETSIZE=1024")
        .flag("-fno-stack-protector")
        .warnings(false)
        .compile("char_server_c");
    
    // Find common build directory - this is a bit hacky but works
    let target_dir = root_dir.parent().unwrap().join("target/debug/build");
    if let Ok(entries) = std::fs::read_dir(&target_dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir() && path.file_name().unwrap().to_str().unwrap().starts_with("common-") {
                let out_dir = path.join("out");
                if out_dir.exists() {
                    println!("cargo:rustc-link-search=native={}", out_dir.display());
                    break;
                }
            }
        }
    }
    
    // Link with libraries
    println!("cargo:rustc-link-search=native={}", yuri_lib_dir.display());
    println!("cargo:rustc-link-lib=static=common_c");
    println!("cargo:rustc-link-lib=static=deps");
    println!("cargo:rustc-link-lib=static=yuri");
    
    // Link MySQL if available
    if let Ok(lib) = pkg_config::Config::new()
        .atleast_version("5.7")
        .probe("mysqlclient") {
        for path in &lib.link_paths {
            println!("cargo:rustc-link-search=native={}", path.display());
        }
        for lib_name in &lib.libs {
            println!("cargo:rustc-link-lib={}", lib_name);
        }
    }
    
    // Link zlib
    println!("cargo:rustc-link-lib=z");
}