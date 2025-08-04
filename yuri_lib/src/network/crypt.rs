use hex;
use md5::{Digest, Md5};

pub fn generate_hash(name: &str) -> String {
    let mut hasher = Md5::new();

    hasher.update(name);
    let result = hasher.finalize();
    return hex::encode(result);
}
