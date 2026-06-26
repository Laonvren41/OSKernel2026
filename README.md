# OSKernel2026

> 2026 全国大学生计算机系统能力大赛 - 操作系统内核实现赛道

本项目基于 [SubsToKernel](https://github.com/wdlin233/osrepo)（北京科技大学 2025 参赛作品），在其基础上进行改进和增量开发。
SubsToKernel 本身基于 [rCore-Tutorial-v3](https://github.com/rcore-os/rCore-Tutorial-v3) ch8 分支。

**所有复制/参考的代码均已在源码中标注来源，详见各源文件头部注释。**
 
## 参赛文档

系统设计方案文档：[docs/design_doc.md](./docs/design_doc.md)

测试截图：[docs/img/test_result.png](./docs/img/test_result.png)

## 参赛信息

- 参赛队名：外卖只点拼好饭
- 队伍ID：T2026104609910064
- 参赛学校：河南理工大学
- 队伍成员：霍启晨，孙铭浩，李辉

## 仓库地址

- [GitLab（比赛平台）](https://gitlab.eduxiji.net/T2026104609910064/oskernel2026-t20261046099100641)
- [GitHub](https://github.com/Laonvren41/OSKernel2026)

## 使用说明

克隆项目：

```shell
git clone https://gitlab.eduxiji.net/T2026104609910064/oskernel2026-t20261046099100641.git
```

编译与运行：

```shell
bash build_all.sh   # 编译双架构内核
bash run_qemu.sh    # QEMU 快速启动（ext4 验证）
bash run_test.sh    # 跑完整测例
```
