use std::env;
use std::path::PathBuf;

include!("../build_helper.rs");

fn main() {
    let root_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let common_dir = root_dir.parent().unwrap().join("common/c_src");
    let deps_dir = root_dir.parent().unwrap().join("common/c_deps");
    let profile = env::var("PROFILE").unwrap_or_else(|_| "debug".to_string());

    // Find LuaJIT using pkg-config
    let luajit = pkg_config::Config::new()
        .probe("luajit")
        .expect("Failed to find LuaJIT");

    // Build map server C code
    let mut build = cc::Build::new();
    build
        .files(&[
            "c_src/map_server.c",
            "c_src/map_parse.c",
            "c_src/map_char.c",
            "c_src/pc.c",
            "c_src/mob.c",
            "c_src/npc.c",
            "c_src/scripting.c",
            "c_src/gm_command.c",
            "c_src/map_crypt.c",
            // Databases
            "c_src/databases/board_db.c",
            "c_src/databases/clan_db.c",
            "c_src/databases/class_db.c",
            "c_src/databases/item_db.c",
            "c_src/databases/magic_db.c",
            "c_src/databases/recipe_db.c",
            "c_src/databases/creation_db.c",
        ])
        .include("c_src")
        .include("c_src/databases")
        .include(&common_dir)
        .include(&deps_dir)
        .includes(&luajit.include_paths)
        .warnings(false);

    // Add standard flags
    for flag in standard_flags() {
        build.flag(flag);
    }

    build.compile("map_server_c");

    // Link LuaJIT
    for path in &luajit.link_paths {
        println!("cargo:rustc-link-search=native={}", path.display());
    }
    for lib in &luajit.libs {
        println!("cargo:rustc-link-lib={}", lib);
    }

    // Link math library
    println!("cargo:rustc-link-lib=m");

    // Find common build directory
    let target_dir = root_dir
        .parent()
        .unwrap()
        .join("target")
        .join(&profile)
        .join("build");
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