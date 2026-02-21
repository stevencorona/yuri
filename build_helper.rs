// Shared build helper functions
use std::path::Path;

pub fn standard_flags() -> Vec<&'static str> {
    vec![
        "-std=gnu17",
        "-DFD_SETSIZE=1024", 
        "-fno-stack-protector",
    ]
}

pub fn find_common_out_dir(target_dir: &Path) -> Option<std::path::PathBuf> {
    if let Ok(entries) = std::fs::read_dir(target_dir) {
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
                    return Some(out_dir);
                }
            }
        }
    }
    None
}

pub fn find_build_dir(target_dir: &Path, prefix: &str) -> Option<std::path::PathBuf> {
    if let Ok(entries) = std::fs::read_dir(target_dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir()
                && path
                    .file_name()
                    .unwrap()
                    .to_str()
                    .unwrap()
                    .starts_with(prefix)
            {
                let out_dir = path.join("out");
                if out_dir.exists() {
                    return Some(out_dir);
                }
            }
        }
    }
    None
}

pub fn link_mysql() {
    if let Ok(lib) = pkg_config::Config::new()
        .atleast_version("5.7")
        .probe("mysqlclient")
    {
        for path in &lib.link_paths {
            println!("cargo:rustc-link-search=native={}", path.display());
        }
        for lib_name in &lib.libs {
            println!("cargo:rustc-link-lib={}", lib_name);
        }
    }
}