#!/bin/bash
echo "=== Building kernel for BOTH RISC-V64 and LoongArch64 ==="
docker run --rm -v "C:/Users/老女人牌握力计/os-contest/osrepo:/code" --privileged docker.educg.net/cg/os-contest:20250226 bash -c '
rm -f /root/.cargo/config /root/.cargo/config.toml
cd /code

# 禁用 vendor（开发阶段）
cat > os/cargo/config.toml << EOF
# No vendor during dev
EOF

# 配置 user crate
mkdir -p user/cargo
cat > user/cargo/config.toml << EOF
[build]
target = "riscv64gc-unknown-none-elf"
EOF

# 编译 RISCV64
echo "--- Building RISC-V64 ---"
cd user && make build ARCH=riscv64 2>&1 | tail -2
cd /code/os && make build ARCH=riscv64 2>&1 | tail -2
cp target/riscv64gc-unknown-none-elf/release/os /code/kernel-rv
echo "kernel-rv: OK"

# 编译 LOONGARCH64
echo "--- Building LoongArch64 ---"
cd /code/user && make build ARCH=loongarch64 2>&1 | tail -2
cd /code/os && make build ARCH=loongarch64 2>&1 | tail -2
cp target/loongarch64-unknown-none/release/os /code/kernel-la
echo "kernel-la: OK"

ls -lh /code/kernel-rv /code/kernel-la
'
echo "=== DONE ==="
