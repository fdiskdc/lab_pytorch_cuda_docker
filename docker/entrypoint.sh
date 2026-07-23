#!/bin/bash

# 动态解析 PORT_RANGE (例如 "5900-5909" 或 "5910-5919")
PORT_RANGE=${PORT_RANGE:-5900-5909}
START_PORT=$(echo "$PORT_RANGE" | cut -d'-' -f1)

# 动态计算前 3 个服务端口
SSH_PORT=$START_PORT
VNC_PORT=$(( START_PORT + 1 ))
VNC_OFFSET=$(( (START_PORT - 5900) + 1 ))
NOVNC_PORT=$(( START_PORT + 2 ))

# 1. 确保挂载到 /home/n401 的宿主机 hdd1 目录所有权属于 n401 用户
chown -R n401:n401 /home/n401

# 2. 保证 conda 在用户家目录初始化成功
if [ -f /opt/conda/bin/conda ]; then
    su - n401 -c "/opt/conda/bin/conda init bash >/dev/null 2>&1 || true"
fi

# 3. 如果首次挂载空目录，自动生成 VNC 密码与桌面启动文件
if [ ! -f /home/n401/.vnc/passwd ]; then
    mkdir -p /home/n401/.vnc
    echo "n401n401" | vncpasswd -f > /home/n401/.vnc/passwd
    chmod 600 /home/n401/.vnc/passwd

    echo '#!/bin/sh' > /home/n401/.vnc/xstartup
    echo 'unset SESSION_MANAGER' >> /home/n401/.vnc/xstartup
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /home/n401/.vnc/xstartup
    echo 'exec startxfce4' >> /home/n401/.vnc/xstartup
    chmod +x /home/n401/.vnc/xstartup
    chown -R n401:n401 /home/n401/.vnc
fi

# 4. 启动 SSH 服务 (自动将 SSH 端口切换为传入端口段的第 1 个端口，如 5900)
sed -i "s/^#\?Port .*/Port $SSH_PORT/" /etc/ssh/sshd_config
service ssh restart

# 5. 清理 VNC 残留锁文件并启动 VNC (绑定为第 2 个端口，如 5901)
rm -f /tmp/.X1-lock /tmp/.X11-unix/X* /home/n401/.vnc/*.pid /home/n401/.vnc/*.log
su - n401 -c "vncserver :$VNC_OFFSET -geometry 1920x1080 -depth 24"

# 6. 启动 noVNC 网页服务 (绑定为第 3 个端口，如 5902，转发至 VNC 端口)
websockify --web /usr/share/novnc $NOVNC_PORT localhost:$VNC_PORT >/dev/null 2>&1 &

# 7. 保持前台常驻
exec tail -f /dev/null