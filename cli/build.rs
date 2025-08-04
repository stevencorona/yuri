use std::env;
use std::path::PathBuf;

include!("../build_helper.rs");

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
        .warnings(false);

    // Add standard flags
    for flag in standard_flags() {
        build.flag(flag);
    }

    build.compile("metan_cli_c");

    // Find common build directory
    let target_dir = root_dir.parent().unwrap().join("target/debug/build");
    if let Some(out_dir) = find_common_out_dir(&target_dir) {
        println!("cargo:rustc-link-search=native={}", out_dir.display());
    }

    // Find map_server build directory for database libs
    if let Some(out_dir) = find_build_dir(&target_dir, "map_server-") {
        println!("cargo:rustc-link-search=native={}", out_dir.display());
        // Link with map server's database object files
        println!("cargo:rustc-link-lib=static=map_server_c");
    }

    // Link with libraries
    println!("cargo:rustc-link-lib=static=common_c");
    println!("cargo:rustc-link-lib=static=deps");

    // Link MySQL (already have lib paths from above)
    for path in &mysql_lib.link_paths {
        println!("cargo:rustc-link-search=native={}", path.display());
    }
    for lib_name in &mysql_lib.libs {
        println!("cargo:rustc-link-lib={}", lib_name);
    }

    // Link zlib
    println!("cargo:rustc-link-lib=z");
}