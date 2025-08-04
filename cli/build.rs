use std::env;
use std::path::PathBuf;

fn main() {
    let root_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let common_dir = root_dir.parent().unwrap().join("common/c_src");
    let deps_dir = root_dir.parent().unwrap().join("common/c_deps");
    let map_server_dir = root_dir.parent().unwrap().join("map_server/c_src");

    // Find MySQL using pkg-config
    let mysql_lib = pkg_config::Config::new()
        .atleast_version("5.7")
        .probe("mysqlclient")
        .expect("Failed to find MySQL client library");

    // Build metan CLI C code
    let mut build = cc::Build::new();
    build
        .file("c_src/metan_cli.c")
        .include("c_src")
        .include(&common_dir)
        .include(&deps_dir)
        .include(&map_server_dir)
        .includes(&mysql_lib.include_paths)
        .flag("-std=gnu17")
        .flag("-DFD_SETSIZE=1024")
        .flag("-fno-stack-protector")
        .warnings(false);

    build.compile("metan_cli_c");

    // Find common build directory - this is a bit hacky but works
    let target_dir = root_dir.parent().unwrap().join("target/debug/build");
    if let Ok(entries) = std::fs::read_dir(&target_dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir()
                && path
                    .file_name()
                    .unwrap()
                    .to_str()
                    .unwrap()
                    .starts_with("common-")
            {
                let out_dir = path.join("out");
                if out_dir.exists() {
                    println!("cargo:rustc-link-search=native={}", out_dir.display());
                    break;
                }
            }
        }
    }

    // Find map_server build directory for database libs
    if let Ok(entries) = std::fs::read_dir(&target_dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir()
                && path
                    .file_name()
                    .unwrap()
                    .to_str()
                    .unwrap()
                    .starts_with("map_server-")
            {
                let out_dir = path.join("out");
                if out_dir.exists() {
                    println!("cargo:rustc-link-search=native={}", out_dir.display());
                    // Link with map server's database object files
                    println!("cargo:rustc-link-lib=static=map_server_c");
                    break;
                }
            }
        }
    }

    // Link with libraries
    println!("cargo:rustc-link-lib=static=common_c");
    println!("cargo:rustc-link-lib=static=deps");

    // Link MySQL
    for path in &mysql_lib.link_paths {
        println!("cargo:rustc-link-search=native={}", path.display());
    }
    for lib_name in &mysql_lib.libs {
        println!("cargo:rustc-link-lib={}", lib_name);
    }

    // Link zlib
    println!("cargo:rustc-link-lib=z");
}
