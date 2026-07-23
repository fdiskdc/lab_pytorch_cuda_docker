# PyTorch Desktop Docker 项目

本目录包含构建包含 PyTorch + CUDA + XFCE 桌面 + TigerVNC + SSH 的 Docker 基础镜像以及 Portainer Stack 部署模板。

## 一、构建基础镜像

在服务器终端进入本目录：
```bash
cd /home/dc/vscode/docker
docker build -t pytorch-desktop:latest .
```

## 二、Portainer 部署说明

1. 登录 Portainer 网页界面。
2. 点击 **Stacks** -> **Add stack**。
3. 复制 `stack-template.yml` 中的内容粘贴至 Web Editor。
4. 添加环境变量：
   - `CONTAINER_NAME`: 容器名称（如 `n401_proj_a`）
   - `HOST_DATA_DIR`: 数据在 hdd1 上的挂载路径（如 `/hdd1/project_a`）
   - `SSH_PORT`: SSH 映射端口（如 `2221`）
   - `VNC_PORT`: VNC 桌面映射端口（如 `5901`）
   - `PORT_3000` ~ `PORT_3007`: 业务端口（如 `3000` ~ `3007`）
5. 点击 **Deploy the stack** 完成部署。
