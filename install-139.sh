#!/bin/bash

# 判断本机的CPU架构和操作系统版本
cpu_arch=$(uname -m)
os_version=$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2)
echo "本机CPU架构：$cpu_arch"
echo "本机操作系统版本：$os_version"

# 检查并安装sudo
if ! command -v sudo &> /dev/null; then
    echo "sudo未安装，正在安装..."
    if [[ "$os_version" == *"Ubuntu"* || "$os_version" == *"Debian"* ]]; then
        apt-get install sudo -y
    elif [[ "$os_version" == *"CentOS"* || "$os_version" == *"Red Hat"* || "$os_version" == *"Fedora"* ]]; then
        yum install sudo -y
    fi
else
    echo "sudo已安装"
fi

# 更新软件包列表
if [[ "$os_version" == *"Ubuntu"* || "$os_version" == *"Debian"* ]]; then
    echo "检测到系统类型为Debian/Ubuntu，正在更新软件包列表..."
    sudo apt-get update -y
elif [[ "$os_version" == *"CentOS"* || "$os_version" == *"Red Hat"* || "$os_version" == *"Fedora"* ]]; then
    echo "检测到系统类型为CentOS/Red Hat/Fedora，正在更新软件包列表..."
    sudo yum update -y
else
    echo "无法识别的操作系统类型。"
    exit 1
fi

# 检查并安装unzip
if ! command -v unzip &> /dev/null; then
    echo "unzip未安装，正在安装..."
    if [[ "$os_version" == *"Ubuntu"* || "$os_version" == *"Debian"* ]]; then
        sudo apt install unzip -y
    elif [[ "$os_version" == *"CentOS"* || "$os_version" == *"Red Hat"* || "$os_version" == *"Fedora"* ]]; then
        sudo yum install unzip -y
    fi
else
    echo "unzip已安装"
fi

# 检查 /usr/local/goedge 目录是否存在
if [ ! -d "/usr/local/goedge" ]; then
    sudo mkdir -p /usr/local/goedge
    echo "安装目录创建成功，默认为/usr/local/goedge"
else
    echo "检测到/usr/local/goedge已存在，您可能已经安装过goedge，无需重复安装，脚本已退出！"
    exit 1
fi

# 修改本机hosts屏蔽官方域名
hosts_entries=(
    "127.0.0.1 goedge.cn"
    "127.0.0.1 goedge.cloud"
    "127.0.0.1 dl.goedge.cloud"
    "127.0.0.1 dl.goedge.cn"
    "127.0.0.1 global.dl.goedge.cloud"
    "127.0.0.1 global.dl.goedge.cn"
)

for entry in "${hosts_entries[@]}"; do
    if ! grep -q "$entry" /etc/hosts; then
        echo "$entry" | sudo tee -a /etc/hosts
    fi
done

echo "已成功屏蔽官方域名通信！"

# 定义 GitHub Release v1.0 的基础下载路径
# 注意：GitHub Release 附件标准格式为: https://github.com/用户名/仓库名/releases/download/版本号/文件名
GITHUB_RELEASE_URL="https://github.com/areyouokbro/goedgenaixi/releases/download/v1.0"

# 下载对应架构程序包
cd /usr/local/goedge
if [[ "$cpu_arch" == "x86_64" ]]; then
    wget "${GITHUB_RELEASE_URL}/edge-admin-linux-amd64-plus-v1.3.9.zip"
    echo "已从 GitHub Release 下载 X86 架构的安装包"
elif [[ "$cpu_arch" == "aarch64" ]]; then
    wget "${GITHUB_RELEASE_URL}/edge-admin-linux-arm64-plus-v1.3.9.zip"
    echo "已从 GitHub Release 下载 ARM 架构的安装包"
else
    echo "不支持的CPU架构"
    exit 1
fi

# 解压缩程序包
unzip -o edge-admin-linux-*.zip

# 进入 edge-admin 目录
cd edge-admin

# 启动 edge-admin 主程序
bin/edge-admin start

# 安装系统服务
bin/edge-admin service

# 删除 /deploy 自带程序包（顺便修正了原脚本中 /delop 的拼写错误）
cd edge-api/deploy
rm -rf *.zip

# 从 GitHub Release v1.0 拉取纯净 plus 版本节点程序包
wget -O edge-node-linux-amd64-v1.3.9.zip "${GITHUB_RELEASE_URL}/edge-node-linux-amd64-plus-v1.3.9.zip"
wget -O edge-node-linux-arm64-v1.3.9.zip "${GITHUB_RELEASE_URL}/edge-node-linux-arm64-plus-v1.3.9.zip"

# 流程执行完毕，输出管理平台地址及通用注册码
clear
ipv4_address=$(curl -s ipv4.ip.sb)
ipv6_address=$(curl -s ipv6.ip.sb)
echo -e "\033[1;33m执行完毕！请通过浏览器访问 http://$ipv4_address:7788/ 或 http://$ipv6_address:7788/ 进入管理平台，并依据页面提示完成最后的安装流程！\033[0m"
echo -e "\033[1;33m如果无法访问，请检查是否已在防火墙/安全组中开放7788端口！\033[0m"
echo -e "-------------"
echo -e "如需激活旗舰版，请于安装完成后，在管理平台依次点击「系统设置」>「商业版本」>「激活」，粘贴下方提供的注册码即可完成离线永久授权："
echo -e "F4BuVYEKSnTYucAwNyVpEh7Q5EIZjV6XisKoinOSE9mBqe2JPgLzRUNIcp+os4RERwS1PYmItplS/qU4EJw+UkeaABEEU9kume1G14e/qzF2ew+PN/mbcKnLXjRikAixKYBN41sliFFpvlN3Ur2YS2XeG4FwjJlGJZpmzwVvNWxbvOloTkNTs/zz6tuScPUKLCbe9QIuTG7jTj5TbOJM4B+zc0JEYZA/oals8HhygfwnwsH33jF4bKp8GLTJXYy7jMH1w6/O9qkjZ4FXqSFY+gVhcIZYuQ=="
echo -e "若要自定义公司组织名，请前往 https://bbs.naixi.net/thread-112-1-1.html 获取注册机"
