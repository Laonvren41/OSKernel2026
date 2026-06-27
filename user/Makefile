ARCH := riscv64

# 绕过rustup代理，直接调toolchain内二进制
TC := /root/.rustup/toolchains/nightly-2025-01-01-x86_64-unknown-linux-gnu/bin
CARGO := $(TC)/cargo
RUSTC := $(TC)/rustc
export CARGO_NET_OFFLINE=true

ifeq ($(ARCH), riscv64)
  	TARGET := riscv64gc-unknown-none-elf
else ifeq ($(ARCH), loongarch64)
  	TARGET := loongarch64-unknown-none
else
  	$(error "ARCH" must be one of "riscv64" or "loongarch64")
endif

MODE := release
APP_DIR := src/bin
TARGET_DIR := target/$(TARGET)/$(MODE)
BUILD_DIR := build
OBJCOPY := rust-objcopy --binary-architecture=riscv64

APPS := $(wildcard $(APP_DIR)/*.rs)
ELFS := $(patsubst $(APP_DIR)/%.rs, $(TARGET_DIR)/%, $(APPS))

binary: config
	@echo $(ELFS)
	$(CARGO) build --release --offline
	@$(foreach elf, $(ELFS), \
		$(OBJCOPY) $(elf) --strip-all -O binary $(patsubst $(TARGET_DIR)/%, $(TARGET_DIR)/%.bin, $(elf)); \
		cp $(elf) $(patsubst $(TARGET_DIR)/%, $(TARGET_DIR)/%.elf, $(elf));)

pre:
	@mkdir -p $(BUILD_DIR)/bin/
	@mkdir -p $(BUILD_DIR)/elf/
	@mkdir -p $(BUILD_DIR)/app/
	@mkdir -p $(BUILD_DIR)/asm/
	@$(foreach t, $(APPS), cp $(t) $(BUILD_DIR)/app/;)

ifeq ($(ARCH),riscv64)
build: env pre binary
	@$(foreach t, $(ELFS), cp $(t).bin $(BUILD_DIR)/bin/;)
	@$(foreach t, $(ELFS), cp $(t) $(BUILD_DIR)/elf/;)
else ifeq ($(ARCH),loongarch64)
build: env
	@echo "It is running on loongarch64 architecture"
	$(CARGO) build --release --target $(TARGET) --offline
endif

config:
	@rm -rf .cargo
	@cp -r cargo .cargo

clean:
	@rm -rf target $(BUILD_DIR)

env:
	# 评测环境无网络，跳过 rustup
	@echo "skipping env setup for offline eval"

all: build

.PHONY: elf binary build clean all config
