//! 关机/重启系统调用，比赛时调试用的
//!
//! 调试用，加了这个方便跑完测例自动关 QEMU

use crate::hal::utils::shutdown;

pub fn sys_shutdown(code: usize) -> isize {
    match code {
        0 => {
            crate::println!("[shutdown] System shutting down...");
            shutdown();
        }
        1 => {
            crate::println!("[shutdown] System rebooting...");
            shutdown();
        }
        _ => {
            crate::println!("[shutdown] Invalid code: {}", code);
            -1
        }
    }
}
