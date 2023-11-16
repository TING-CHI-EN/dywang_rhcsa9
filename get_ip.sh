#!/bin/bash

# 使用curl获取IP地址
IP=$(curl -s ifconfig.me)

# 将IP地址写入文件
echo "$IP 11227608 丁啟恩" > sid
