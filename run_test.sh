#!/bin/bash
"/c/Program Files/qemu/qemu-system-riscv64.exe" \
  -machine virt -kernel kernel-rv -m 2G -nographic -smp 2 \
  -bios default \
  -drive file=sdcard-rv-test.img,if=none,format=raw,id=x0 \
  -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0 \
  -no-reboot \
  -device virtio-net-device,netdev=net -netdev user,id=net
