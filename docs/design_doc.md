# OSKernel2026 设计方案文档

> 2026 全国大学生计算机系统能力大赛 - 操作系统内核实现赛道
> 
> 队伍：外卖只点拼好饭 (T2026104609910064) | 学校：河南理工大学 | 成员：霍启晨，孙铭浩，李辉

---

## 1. 项目概述

### 1.1 项目背景

本项目旨在实现一个面向 RISC-V64 和 LoongArch64 双架构的操作系统内核，支持在 QEMU 虚拟环境及物理开发板上运行。

### 1.2 基础版本说明

本项目基于以下开源作品进行增量开发：

| 项目 | 仓库 | 说明 |
|------|------|------|
| **SubsToKernel** | https://github.com/wdlin233/osrepo | 北京科技大学 2025 年参赛作品 |
| **rCore-Tutorial-v3** | https://github.com/rcore-os/rCore-Tutorial-v3 | 清华大学 rCore 教学内核 ch8 分支 |

**所有引用、复制、修改的代码均已在对应源文件头部标注来源。**

### 1.3 增量贡献

相比于基础版本，本项目的改进包括：

- [x] 适配 2026 年比赛评测环境（工具链 nightly-2025-01-18，Docker os-contest:20250226）
- [x] 新增 `sys_shutdown` 系统调用（#410）：用户程序可发起关机/重启
- [x] 新增 `sys_meminfo` 系统调用（#411）：获取物理内存使用统计
- [x] 帧分配器增加 `free_count()` / `total_count()` 统计接口
- [ ] （继续列出后续功能改进）

---

## 2. 系统架构

### 2.1 整体架构

```
┌─────────────────────────────────────┐
│           用户程序 (User)            │
├─────────────────────────────────────┤
│     系统调用接口 (Syscall Layer)      │
├──────┬──────┬──────┬──────┬─────────┤
│ 进程 │ 内存 │ 文件 │ 信号 │ 网络    │
│ 管理 │ 管理 │ 系统 │ 机制 │ 协议栈   │
├──────┴──────┴──────┴──────┴─────────┤
│      硬件抽象层 (HAL)                │
├─────────────────┬───────────────────┤
│  RISC-V64       │  LoongArch64      │
├─────────────────┴───────────────────┤
│     virtio 驱动 (block / net)        │
├─────────────────────────────────────┤
│           QEMU / 物理硬件            │
└─────────────────────────────────────┘
```

### 2.2 支持的架构

- **RISC-V64**：Sv39 页表，QEMU virt 平台
- **LoongArch64**：LA64 页表，QEMU virt + 2K1000 开发板

### 2.3 开发语言与工具链

- 编程语言：Rust (edition 2021)
- 工具链：nightly-2025-01-18
- 构建系统：Cargo + Makefile
- 模拟器：QEMU 11.0+
- 容器化：Docker (os-contest:20250226)

---

## 3. 核心模块设计

### 3.1 内存管理

- **物理帧分配器**：基于 LIFO 栈的帧分配
- **虚拟内存**：Sv39 三级页表（RISC-V64）/ LA64 页表（LoongArch64）
- **内核堆**：Buddy System 分配器
- **用户地址空间**：支持 mmap、munmap、sbrk 等

### 3.2 进程管理

- **进程控制块（PCB）**：管理进程状态、地址空间、文件描述符
- **调度器**：Round-Robin 调度
- **进程操作**：fork、exec、waitpid、exit
- **线程支持**：thread_create、gettid、waittid

### 3.3 文件系统

- **支持的文件系统**：EXT4（基于 lwext4_rust）
- **VFS 层**：统一文件操作接口
- **特殊文件系统**：devfs、pipefs

### 3.4 系统调用

已实现 100+ 个兼容 POSIX 标准的系统调用，包括：

| 类别 | 主要系统调用 |
|------|-------------|
| 文件 | open, close, read, write, lseek, getdents64, fstat, statx, mmap, munmap |
| 进程 | fork, exec, waitpid, exit, getpid, sched_yield |
| 内存 | brk, mmap, munmap, mprotect, msync |
| 网络 | socket, bind, listen, accept, connect, sendto, recvfrom |
| 信号 | sigaction, sigprocmask, sigreturn, kill, tkill |
| 同步 | futex, mutex, semaphore, condvar |

### 3.5 网络协议栈

- 基于 smoltcp 的 TCP/IP 协议栈
- 支持 TCP/UDP socket
- virtio-net 驱动

### 3.6 设备驱动

- **virtio-block**：块设备驱动（ext4 存储）
- **virtio-net**：网络设备驱动
- **UART**：串口控制台

---

## 4. 与基础版本的差异

### 4.1 保留的基础功能

- rCore-Tutorial-v3 ch8 的核心架构（进程管理、内存管理、文件系统）
- SubsToKernel 的 ext4 支持、LoongArch 适配、网络协议栈
- 100+ 系统调用实现

### 4.2 本项目的改进

（此处列出你的具体改进，例如：）
- 适配 2026 年比赛工具链（nightly-2025-01-18）
- 修复 LoongArch64 编译兼容性问题
- （更多改进...）

---

## 5. 构建与运行

### 5.1 环境要求

- Docker: docker.educg.net/cg/os-contest:20250226
- QEMU: 9.0+ (RISC-V64 + LoongArch64)
- Rust: nightly-2025-01-18

### 5.2 编译

```bash
# 完整编译（双架构）
bash build_all.sh
```

### 5.3 运行

```bash
# RISC-V64
bash run_qemu.sh
```

---

## 6. 测试情况

### 6.1 测试环境

- QEMU 11.0.50, RISC-V64 virt machine
- 内存: 2GB, SMP: 2 cores
- 块设备: virtio-blk, ext4 文件系统
- 测例镜像: sdcard-rv-test.img (4GB)

### 6.2 测试结果

| 测例类别 | RISC-V64 | 通过/总数 | 备注 |
|----------|----------|-----------|------|
| lmbench | ✅ | 通过 | I/O 带宽 116MB/s, open/close 73μs |
| libc-test (动态) | ❌ | 0/110 | 缺动态链接器，非内核问题 |
| libc-test (静态) | ✅ | ~108/110 | 仅 utime, fgetwc 失败 |
| busybox | ✅ | 40+/45 | date, df, stat, wc, grep 等通过 |
| basic | ✅ | 28/28 | 全部通过 |
| lua | ✅ | 9/9 | 全部通过 |

![测试截图](docs/img/test_result.png)

### 6.3 调试过程中遇到的问题

1. 测例脚本 CRLF 换行符导致 `: not found` 错误，转换为 LF 后解决
2. `fgetwc_buffering` 管道读写会阻塞，跳过该测例
3. `sys_readlinkat` 原版 `unwrap()` 在文件不存在时 panic，改为返回错误码
4. 父进程退出后子进程 `unwrap()` 崩溃，加了空值判断

### 6.4 测试命令

```bash
bash build_all.sh   # 编译
bash run_test.sh    # 跑测例
```

---

## 7. AI 工具使用

开发过程中使用了 VSCode 的 AI 代码补全功能辅助编码，偶尔用于查编译报错原因和调试。

---

## 8. 开源协议

- 源代码：GPL-3.0
- 技术文档 / 答辩材料：CC-BY-SA 4.0

---

## 9. 参考资料

1. rCore-Tutorial-Book: https://rcore-os.cn/rCore-Tutorial-Book-v3/
2. RISC-V 特权指令集规范: https://riscv.org/technical/specifications/
3. 龙芯架构参考手册: https://loongson.cn/
4. virtio 规范: https://docs.oasis-open.org/virtio/virtio/v1.2/
