FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-devel
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# 1. 安装 XFCE 桌面、图标主题库 (adwaita/tango)、VNC、noVNC 及基础工具
RUN sed -i 's@//archive.ubuntu.com@//mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list && \
    sed -i 's@//security.ubuntu.com@//mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    xfce4 \
    xfce4-goodies \
    adwaita-icon-theme-full \
    tango-icon-theme \
    hicolor-icon-theme \
    tigervnc-standalone-server \
    tigervnc-common \
    tigervnc-tools \
    novnc \
    websockify \
    dbus-x11 \
    sudo \
    curl \
    wget \
    git \
    vim \
    net-tools \
    htop \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. 配置 SSH 目录
RUN mkdir /var/run/sshd

# 3. 环境变量指向原本的 Conda 路径
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# 4. 创建默认用户 n401 并配置权限
RUN useradd -ms /bin/bash n401 && \
    echo "n401:n401n401" | chpasswd && \
    usermod -aG sudo n401 && \
    chown -R n401:n401 $CONDA_DIR

# 为 n401 用户初始化 conda
USER n401
RUN $CONDA_DIR/bin/conda init bash

USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 禁止 apt 安装或更新 nvidia 显卡驱动
RUN echo "Package: nvidia-driver-* cuda-drivers* nvidia-kernel-*\nPin: release *\nPin-Priority: -1" > /etc/apt/preferences.d/block-nvidia-drivers

EXPOSE 22 5901 6080 3000 3001 3002 3003 3004 3005 3006

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]