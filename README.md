# GoEdge v1.3.9 奶昔开心版 (Naixi) 备份仓库
本仓库用于备份和存档 **GoEdge v1.3.9 奶昔 开心 版** 相关组件及安装脚本。旨在解决原下载链接失效或网络连接不稳定的问题，并提供一键部署方案。
> **原文参考**：奶昔论坛 - GoEdge Admin plus v1.3.9 发布页
> 
## 📦 包含组件
 * **主控端 (Admin)**：v1.3.9 Plus 版（支持 AMD64 / ARM64）。
 * **节点端 (Node)**：v1.3.9 Plus 纯净版（已预置于 deploy 目录）。
 * **激活系统**：内置通用离线授权码。
 * **安装脚本**：自动识别架构、修改 hosts 屏蔽官方验证、一键部署环境。
## 🛠️ 安装方法 (备份脚本)
执行本仓库备份的一键脚本：
```bash
curl -sSO https://raw.githubusercontent.com/areyouokbro/goedgenaixi/refs/heads/main/install-139.sh && bash install-139.sh

```
## 🔑 离线授权码 (License)
在主控后台 **「系统设置」** -> **「商业版本」** -> **「激活」** 中粘贴：
```text
F4BuVYEKSnTYucAwNyVpEh7Q5EIZjV6XisKoinOSE9mBqe2JPgLzRUNIcp+os4RERwS1PYmItplS/qU4EJw+UkeaABEEU9kume1G14e/qzF2ew+PN/mbcKnLXjRikAixKYBN41sliFFpvlN3Ur2YS2XeG4FwjJlGJZpmzwVvNWxbvOloTkNTs/zz6tuScPUKLCbe9QIuTG7jTj5TbOJM4B+zc0JEYZA/oals8HhygfwnwsH33jF4bKp8GLTJXYy7jMH1w6/O9qkjZ4FXqSFY+gVhcIZYuQ==

```
## 📝 备份说明
 1. **Host 屏蔽**：脚本会自动在 /etc/hosts 加入以下条目，以阻断主控与官方服务器的通信：
   * goedge.cn, goedge.cloud, dl.goedge.cloud 等。
 2. **目录规范**：
   * 安装路径：/usr/local/goedge
   * 节点包路径：/usr/local/goedge/edge-admin/edge-api/deploy/（已存放 ARM 和 AMD64 包，方便后台直接推送安装）。
 3. **架构支持**：脚本支持 x86_64 (AMD64) 及 aarch64 (ARM64) 自动识别。
## ⚠️ 风险提示
 * 本仓库仅作为技术存档和个人备份使用。
 * 建议在纯净系统（Debian 11/12 或 Ubuntu 20.04+）上运行。
 * 请确保防火墙已放行 7788、80、443 等必要端口。
**Source**: 奈斯奶昔论坛
**Maintainer**: areyouokbro
