Aria2 latest 'master' branch on Alpine Linux 'edge'
-----------------------------------

### 0.镜像介绍
使用alpine Linux edge分支+aria2 master分支编译。即最新鲜的稳定代码。偏安全向和尝鲜向。

主要面对希望尝鲜人群以及因为aria2长期不发新版本而无法使用某些功能的用户（比如[TLS v1.3支持](https://unix.stackexchange.com/a/523465/196243)）

本镜像只包含aria2，不包含其前端。前端可选择[AriaNG](https://ariang.mayswind.net/latest/#!/settings/ariang)或者[WebUI-Aria2](https://ziahamza.github.io/webui-aria2/)。推荐后者（因其托管在GitHub上，安全性更有保障）

### 1.使用
1. `docker pull truebit/alpine-aria2-latest`
2. `docker run -e UID=0 -e GID=0 -e 
RPC_SECRET=exampleSecret -e RPC_SECURE=true -v /volume1/Downloads:/data -v /volume2/docker/conf/key:/app/conf/key -v /volume2/docker/conf:/app/conf -p 6888:6800 truebit/alpine-aria2-latest`
3. 或者自己执行命令：`docker run  truebit/alpine-aria2-latest aria2c --help`

群晖设置请移步：[https://zhuanlan.zhihu.com/p/82595126](https://zhuanlan.zhihu.com/p/82595126)

### 2.环境参数说明

* GID和UID：宿主机的gid和uid，可使用命令`id`得到。不设置可能导致下载文件夹无法写入等问题
* RPC_SECRET：RPC链接的密码令牌（即token），任意字符。
* RPC_SECURE：`true`或者其他。true时开启RPC HTTPS
* ENABLE_AUTH: `true`或者其他。true时下面的RPC_USER/PASSWORD生效
* RPC_USER：RPC连接用户名，不建议使用。推荐使用RPC_SECRET
* RPC_PASSWORD：与RPC_USER同时使用。不推荐使用，推荐RPC_SECRET

### 3.卷（volume）挂载说明

* `/data`：下载文件夹
* `/app/conf/key`：RPC HTTPS证书文件夹。文件夹中证书名须为`aria2.cer`和`aria2.key`
* `/app/conf`：aria2配置文件夹。如不挂载，则使用docker内部配置

### 4.端口说明
默认暴露6800端口，自行映射到宿主机上
