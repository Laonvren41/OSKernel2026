//! 看内存用了多少的 syscall，主要是调试的时候想知道还剩多少内存

#[repr(C)]
pub struct MemInfo {
    pub total_mem: usize,   // 总物理内存
    pub free_mem: usize,    // 空闲内存
    pub used_mem: usize,    // 已用内存
    pub total_pages: usize, // 总页数
    pub free_pages: usize,  // 空闲页数
    pub heap_used: usize,   // 堆用了多少，还没实现
}

pub fn sys_meminfo(info_ptr: *mut MemInfo) -> isize {
    if info_ptr.is_null() {
        return -1;
    }

    let free_pages = crate::mm::frame_allocator::free_count();
    let total_pages = crate::mm::frame_allocator::total_count();

    let info = MemInfo {
        total_mem: total_pages * crate::config::PAGE_SIZE,
        free_mem: free_pages * crate::config::PAGE_SIZE,
        used_mem: (total_pages - free_pages) * crate::config::PAGE_SIZE,
        total_pages,
        free_pages,
        heap_used: 0, // Heap stats TODO
    };

    unsafe {
        core::ptr::write(info_ptr, info);
    }

    crate::println!(
        "[meminfo] total={} free={} used={} pages",
        total_pages, free_pages, total_pages - free_pages
    );

    0
}
