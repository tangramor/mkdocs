# 使用 mkdocs 构建静态文档网站

本项目是一个 mkdocs 的模版，除了缺省的 mkdocs 的组织结构，添加了对 Gitlab Pages 的支持和 PDF 自动生成（包含中文）的支持，请参考 [docs/index.md](./docs/index.md) 进一步了解。

为了方便使用，本项目下的 Dockerfile 能够帮你创建一个包含了所需程序的容器环境，如果你安装了 docker，那么运行下面的命令即可以当前目录为工作路径来运行容器：

```
docker run --name mkdocs -d -it -p 80:80 -v ${PWD}:/data tangramor/mkdocs
```

或者自己构建 Docker 镜像：

```
docker build -t mkdocs .
docker run --name mkdocs -d -it -p 80:80 -v ${PWD}:/data mkdocs
```

然后就可以通过 `docker exec -it mkdocs bash` 进入此容器来运行 mkdocs 命令了。

进入容器后，在 /data 目录下可以创建文档项目，然后进入文档项目，运行如下命令：

```
mkdocs serve &
socat -d tcp-listen:80,reuseaddr,fork tcp:127.0.0.1:8000 &
```

然后用浏览器访问 http://192.168.99.100 即可（Windows下Docker缺省IP一般是这个，如果是Mac或Linux，直接访问 http://127.0.0.1 ）


