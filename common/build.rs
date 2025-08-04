use std::env;
use std::path::PathBuf;

fn main() {
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let root_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let deps_dir = root_dir.join("c_deps");
    
    // Find MySQL using pkg-config
    let mysql_lib = pkg_config::Config::new()
        .atleast_version("5.7")
        .probe("mysqlclient")
        .expect("Failed to find MySQL client library");
    
    // Build common C library
    cc::Build::new()
        .files(&[
            "c_src/config.c",
            "c_src/session.c", 
            "c_src/net_crypt.c",
        ])
        .include("c_src")
        .include(&deps_dir)
        .include("c_deps")
        .includes(&mysql_lib.include_paths)
        .flag("-std=gnu17")
        .flag("-DFD_SETSIZE=1024")
        .flag("-fno-stack-protector")
        .warnings(false)
        .compile("common_c");
    
    // Build c_deps
    cc::Build::new()
        .files(&[
            deps_dir.join("db.c"),
            deps_dir.join("db_mysql.c"),
            deps_dir.join("ers.c"),
            deps_dir.join("md5calc.c"),
            deps_dir.join("rndm.c"),
            deps_dir.join("showmsg.c"),
            deps_dir.join("strlib.c"),
            deps_dir.join("timer.c"),
        ])
        .include(&deps_dir)
        .includes(&mysql_lib.include_paths)
        .flag("-std=gnu17")
        .flag("-DFD_SETSIZE=1024")
        .flag("-fno-stack-protector")
        .warnings(false)
        .compile("deps");

    // Link MySQL
    for path in &mysql_lib.link_paths {
        println!("cargo:rustc-link-search=native={}", path.display());
    }
    for lib in &mysql_lib.libs {
        println!("cargo:rustc-link-lib={}", lib);
    }
    
    // Link zlib
    println!("cargo:rustc-link-lib=z");
    
    // Export metadata for dependent crates
    println!("cargo:metadata=COMMON_OUT_DIR={}", out_dir.display());
    
    // Make the libraries available to dependent crates
    println!("cargo:rustc-link-search=native={}", out_dir.display());
}