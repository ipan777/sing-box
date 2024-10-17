#!/bin/bash

# 定义颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

# 根据系统架构自动判定 warp-reg 下载链接
get_warp_reg() {
    arch=$(uname -m)
    if [[ "$arch" == "x86_64" ]]; then
        download_url="https://github.com/badafans/warp-reg/releases/download/v1.0/main-linux-amd64"
    elif [[ "$arch" == "aarch64" ]]; then
        download_url="https://github.com/badafans/warp-reg/releases/download/v1.0/main-linux-arm64"
    elif [[ "$arch" == "armv7l" ]]; then
        download_url="https://github.com/badafans/warp-reg/releases/download/v1.0/main-linux-arm"
    else
        echo -e "${RED}不支持的系统架构: $arch${RESET}"
        exit 1
    fi

    # 下载并执行 warp-reg
    output=$(curl -sLo warp-reg "$download_url" && chmod +x warp-reg && ./warp-reg && rm warp-reg)

    # 使用 grep 提取需要的字段
    wprivate_key=$(echo "$output" | grep -oP '(?<=private_key: ).*')
    v6=$(echo "$output" | grep -oP '(?<=v6: ).*')
    reserved=$(echo "$output" | grep -oP '(?<=reserved: \[ ).*(?= \])')

    # 输出提取的信息
    echo -e "${GREEN}Reserved: $reserved${RESET}"
    echo -e "${GREEN}IPv6: $v6${RESET}"
    echo -e "${GREEN}Private Key: $wprivate_key${RESET}"
}

# 主程序
main() {
    get_warp_reg
}

# 执行主程序
main
