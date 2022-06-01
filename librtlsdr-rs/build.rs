extern crate bindgen;

use std::env;
use std::path::PathBuf;

fn main() {
    println!("{}", format!("cargo:rustc-link-search={}", env::var("LIB_PATH").unwrap()));
    println!("cargo:rustc-link-lib=rtlsdr");
    
    let bindings = bindgen::Builder::default()
    .header(env::var("HEADER_FILEPATH").unwrap())
    .clang_arg(format!("-I{}", env::var("INC_PATH").unwrap()))
    .parse_callbacks(Box::new(bindgen::CargoCallbacks))
    .generate()
    .expect("Error generate bindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("librtlsdr_bindings.rs"))
        .expect("Error writing bindings");
}