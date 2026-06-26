#!/bin/bash
docker run --rm -v "C:/Users/老女人牌握力计/os-contest/osrepo:/code" --privileged docker.educg.net/cg/os-contest:20250226 bash -c "rm -f /root/.cargo/config /root/.cargo/config.toml && cd /code/os && make build ARCH=loongarch64" 2>&1 | tail -40
