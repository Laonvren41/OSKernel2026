# OSKernel2026

> 2026 全国大学生计算机系统能力大赛 - 操作系统内核实现赛道

本项目基于 [SubsToKernel](https://github.com/wdlin233/osrepo)（北京科技大学 2025 参赛作品），在其基础上进行改进和增量开发。
SubsToKernel 本身基于 [rCore-Tutorial-v3](https://github.com/rcore-os/rCore-Tutorial-v3) ch8 分支。

**所有复制/参考的代码均已在源码中标注来源，详见各源文件头部注释。**
 
## 参赛文档

系统介绍文档在 [docs](./docs/) 文件夹。可以分别在此查看[初赛参赛文档](./docs/prel/初赛文档.md)，[决赛文档](./docs/final/决赛文档.md)，和[现场赛文档](./docs/site/现场赛文档.md)。

测试初赛测例的分支为[当前分支](https://github.com/wdlin233/osrepo)，决赛测例为 [final-test](https://github.com/wdlin233/osrepo/tree/final-test)，现场赛分支为 [git-site](https://github.com/wdlin233/osrepo/tree/git-site)。

[GitLab 仓库](https://gitlab.eduxiji.net/T202510008995695/oskernel2025-osrepo) 与 [GitHub 仓库](https://github.com/wdlin233/osrepo) 保持同步。

## 参赛信息

- 参赛队名：外卖只点拼好饭
- 队伍ID：T2026104609910064
- 参赛学校：河南理工大学
- 队伍成员：（待填）

## 使用说明

克隆项目后，在项目根目录下运行 `make run [LOG=<日志级别>] [ARCH=<目标架构>]` 即可启动 QEMU 运行内核。

需要在根目录准备 `sdcard-rv.img` 和 `sdcard-la.img` 两个镜像文件，可以选择 `riscv64` 和 `loongarch64` 两个架构，例如：

```shell
make run LOG=DEBUG ARCH=riscv64
```

`make all` 可以在根目录下构建 `kernel-rv` 和 `kernel-la` 两个 ELF 文件。

初始进程的链接设置位于 `os/src/task/initproc_*.S` 中，通过将初始进程的 ELF 文件链接到内核镜像中，从而在系统启动后运行，可以修改 `.incbin` 来链接不同的应用程序作为初始进程。链接的文件必须要是 ELF 格式文件。
