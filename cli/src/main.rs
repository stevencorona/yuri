use clap::{Parser, Subcommand};
use std::ffi::CString;
use std::os::raw::{c_char, c_int};

extern "C" {
    fn metan_main(argc: c_int, argv: *const *const c_char) -> c_int;
}

#[derive(Parser)]
#[command(name = "yuri-cli")]
#[command(about = "Yuri server CLI tools", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate metadata files for items and characters
    Metan {
        /// Optional arguments to pass to metan
        #[arg(trailing_var_arg = true)]
        args: Vec<String>,
    },
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Metan { args } => {
            // Prepare arguments for C function
            let mut c_args: Vec<CString> = vec![
                CString::new("metan").expect("Failed to create CString"),
            ];
            
            for arg in args {
                c_args.push(CString::new(arg).expect("Failed to create CString"));
            }
            
            let c_argv: Vec<*const c_char> = c_args
                .iter()
                .map(|arg| arg.as_ptr())
                .collect();
            
            unsafe {
                let result = metan_main(c_argv.len() as c_int, c_argv.as_ptr());
                std::process::exit(result);
            }
        }
    }
}