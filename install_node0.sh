#!/bin/bash
# ================================================
# Node0 Auto Installer Script - Node9X (Final)
# ================================================

# Yêu cầu nhập biến
read -p "Nhập ANNOUNCE_PORT: " ANNOUNCE_PORT
read -p "Nhập HF_TOKEN: " HF_TOKEN
read -p "Nhập EMAIL_ADDRESS: " EMAIL_ADDRESS

# Cập nhật hệ thống
echo -e "\033[1;32m[1/7] Updating system packages...\033[0m"
sudo apt update && sudo apt upgrade -y

# Cài đặt công cụ cần thiết
echo -e "\033[1;32m[2/7] Installing general utilities...\033[0m"
sudo apt install -y screen curl iptables build-essential git wget lz4 jq make gcc nano \
automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar \
clang bsdmainutils ncdu unzip libleveldb-dev

# Cài đặt Python và pip
echo -e "\033[1;32m[3/7] Installing Python and pip...\033[0m"
sudo apt install -y python3-pip build-essential libssl-dev libffi-dev python3-dev

# Cài đặt Miniconda
echo -e "\033[1;32m[4/7] Installing Miniconda...\033[0m"
mkdir -p ~/miniconda3
wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
source ~/miniconda3/bin/activate
conda init --all
source ~/.bashrc

# Clone repo Node0
echo -e "\033[1;32m[5/7] Cloning Node0 repository...\033[0m"
git clone https://github.com/PluralisResearch/node0
cd node0

# Tạo và kích hoạt môi trường conda
echo -e "\033[1;32m[6/7] Creating and activating conda environment...\033[0m"
conda create -n node0 python=3.11 -y
source ~/miniconda3/bin/activate
conda activate node0

# Cài đặt Node0
pip install .

# Sinh file start_server.sh
echo -e "\033[1;32m[7/7] Generating start_server.sh...\033[0m"
python3 generate_script.py --host_port 49200 --announce_port "$ANNOUNCE_PORT" --token "$HF_TOKEN" --email "$EMAIL_ADDRESS" <<EOF
N
EOF

# Tự động mở tmux session và chạy Node0
echo -e "\033[1;33m====================================================\033[0m"
echo -e "\033[1;32mCài đặt hoàn tất!\033[0m"
echo -e "File \033[1;36mstart_server.sh\033[0m đã được tạo."
echo -e "Đang khởi chạy Node0 trong tmux session \033[1;36mpluralis\033[0m..."

tmux new -d -s pluralis "bash -c './start_server.sh'"

echo -e "\033[1;32mNode0 đã được khởi chạy.\033[0m"
echo -e "Để attach vào session, chạy: \033[1;35mtmux attach -t pluralis\033[0m"
echo -e "\033[1;33m====================================================\033[0m"
