本文说明一下PHP Laravel（包含Lumen）开发下的Docker化部署，写到了使用 CentOS 6.9、CentOS 7.0 进行生产环境部署，并使用了 Kong 来作为 API 网关进行鉴权。

## Docker开发环境

首先，我们需要在开发环境下安装 Docker。这部分网络上的资料汗牛充栋，就不赘述了。

在项目根目录下创建 `Dockerfile`。 我们使用了 `richarvey/nginx-php-fpm` 作为基础镜像，相关资料可以查阅[其项目文档](https://gitlab.com/ric_harvey/nginx-php-fpm/tree/master/docs)。

```
FROM richarvey/nginx-php-fpm:1.5.7

RUN sed -i "s/try_files \$uri \$uri\/ =404;/try_files \$uri \$uri\/ \/index.php?\$query_string;/g" /etc/nginx/sites-available/default.conf \
  && sed -i "s/try_files \$uri \$uri\/ =404;/try_files \$uri \$uri\/ \/index.php?\$query_string;/g" /etc/nginx/sites-available/default-ssl.conf \
  && sed -i "s/root \/var\/www\/html/root \/var\/www\/html\/public/g" /etc/nginx/sites-available/default.conf \
  && sed -i "s/root \/var\/www\/html/root \/var\/www\/html\/public/g" /etc/nginx/sites-available/default-ssl.conf

```

然后创建 `docker-compose.yml` 文件：

```
version: '3'
services:

  web:
    build: .
    volumes:
      - .:/var/www/html
    ports:
     - "80:80"
     - "443:443"
    depends_on:
      - redis
      - db
    links:
      - redis
      - db

  redis:
    image: redis

  db:
    image: mysql:5.7
    volumes:
      - ./db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: appdb
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppassword

```

在项目配置 `.env` 里配置相应的redis和数据库信息：

```
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=appdb
DB_USERNAME=appuser
DB_PASSWORD=apppassword

CACHE_DRIVER=redis

REDIS_HOST=redis:6379
REDIS_PORT=6379

```

然后执行 `docker-compose up` ，docker会自动构建支持 Laravel 的镜像并将当前项目目录挂载到容器 `/var/www/html` 目录下。这样就可以在docker环境下进行开发了。



## Docker生产镜像

首先修改 `.env` ，以适配生产环境的相关信息，例如数据库名称、密码等等。这些信息和后面部署时用到的需要一致。

Dockerfile_production:

```
FROM richarvey/nginx-php-fpm:1.5.7

COPY . /var/www/html/

RUN sed -i "s/try_files \$uri \$uri\/ =404;/try_files \$uri \$uri\/ \/index.php?\$query_string;/g" /etc/nginx/sites-available/default.conf \
  && sed -i "s/try_files \$uri \$uri\/ =404;/try_files \$uri \$uri\/ \/index.php?\$query_string;/g" /etc/nginx/sites-available/default-ssl.conf \
  && sed -i "s/root \/var\/www\/html/root \/var\/www\/html\/public/g" /etc/nginx/sites-available/default.conf \
  && sed -i "s/root \/var\/www\/html/root \/var\/www\/html\/public/g" /etc/nginx/sites-available/default-ssl.conf

```

使用以下命令构建生产环境镜像：

```
docker build -t prod_web -f Dockerfile_production .
```


## 在CentOS 6.9环境的部署

因为条件所限，有些服务器OS版本比较低（CentOS6.9），安装所需的软件包会比较麻烦，所以需要进行一些升级来运行docker容器环境。

### 首先升级内核

（从elrepo仓库下载最新的稳定版内核，修改grub.conf以使用最新内核，禁用selinux，然后重启）：

```
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install -y kernel-lt

sed -i 's/default=1/default=0/g' /etc/grub.conf

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

reboot
```

### 然后安装docker

（安装epel仓库，安装docker-io，设置docker随系统启动并启动docker）：

```
yum -y remove epel-release-6-8
yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum install -y docker-io

chkconfig --list | grep docker
chkconfig docker on
service docker start
```

### 部署docker镜像

docker-io不支持docker-compose（项目中的 `docker-compose.yml` 只能用在开发环境或CentOS7上的容器环境），所以镜像只能使用 `docker run` 来创建容器。

将前面构建的生产环境镜像导出到文件：

```
docker save -o prod_web.tar prod_web
```

把镜像上传到CentOS6.9服务器上，导入为本地镜像：

```
docker load -i prod_web.tar
```

在CentOS6.9服务器上按顺序执行以下脚本：

* 1_run_redis.sh:

```
#!/bin/bash
docker run -it -d --name redis \
  -p 6379:6379 \
  --restart=always \
  redis
```

* 2_run_cassandra.sh:

```
#/bin/bash
docker run --name cassandra \
    -v /data/cassandra:/var/lib/cassandra \
    -d --restart=always\
    -p 9042:9042 \
    cassandra:3
```

* init_kong_db.sh: 注意此脚本只应该跑一次

```
#/bin/bash
docker run --rm \
    --link cassandra \
    -e "KONG_DATABASE=cassandra" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=cassandra" \
    kong:latest kong migrations up
```

* 3_run_mysql.sh:

```
#!/bin/bash
docker run -it -d --name db \
    -v /data/mysql:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=rootpass \
    -e MYSQL_DATABASE=appdb \
    -e MYSQL_USER=appuser \
    -e MYSQL_PASSWORD=apppassword \
    -p 3306:3306 \
    --restart=always \
    mysql:5.7
```

* 4_run_prod.sh:

```
#/bin/bash

mkdir -p /data/prod_storage
chmod -R 777 /data/prod_storage

docker run -it -d --name prod \
    --restart=always \
    -p 8080:80 \
    -v /data/prod_storage:/var/www/storage \
    --link redis:redis \
    --link db:db \
    prod_web
```

* 5_run_kong.sh:

```
#/bin/bash

mkdir -p /data/kong_log

docker run --name kong \
    -d --restart=always \
    -e "KONG_DATABASE=cassandra" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=cassandra" \
    -e "KONG_PROXY_ACCESS_LOG=/data/kong_log/proxy_access.log" \
    -e "KONG_ADMIN_ACCESS_LOG=/data/kong_log/admin_access.log" \
    -e "KONG_PROXY_ERROR_LOG=/data/kong_log/proxy_error.log" \
    -e "KONG_ADMIN_ERROR_LOG=/data/kong_log/admin_error.log" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -p 80:8000 \
    -p 443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    -v /data/kong_log:/data/kong_log \
    --link cassandra \
    --link prod \
    kong:latest
```


后面如果 prod_web 镜像有了修改，我们需要删掉正在运行的 `prod` 和 `kong` 两个容器，然后重新导入镜像，创建 `prod` 和 `kong` 两个容器：

```
docker stop prod kong && docker rm prod kong

docker load -i prod_web.tar

./4_run_prod.sh
./5_run_kong.sh
```

### 创建 kong API网关

* 创建服务 `prod-service`，注意url里引用的网址是容器名称：

```
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=prod-service' \
  --data 'url=http://prod'
```

返回类似如下：

```
{"host":"prod","created_at":1539931317,"connect_timeout":60000,"id":"0dff5819-627e-41d5-8ca0-5fa8c7362d1e","protocol":"http","name":"prod-service","read_timeout":60000,"port":80,"path":null,"updated_at":1539931317,"retries":5,"write_timeout":60000}
```


* 为服务 `prod-service` 创建路由，只要访问域名 `prod.test.com`，即调用此路由的规则：

```
curl -i -X POST \
  --url http://localhost:8001/services/prod-service/routes \
  --data 'hosts[]=prod.test.com'
```

返回类似如下：

```
{"created_at":1539931349,"strip_path":true,"hosts":["prod.test.com"],"preserve_host":false,"regex_priority":0,"updated_at":1539931349,"paths":null,"service":{"id":"0dff5819-627e-41d5-8ca0-5fa8c7362d1e"},"methods":null,"protocols":["http","https"],"id":"3a38359a-b5b9-482b-8c8e-40fb7f8b70e7"}
```

* ~~为路由添加SSL证书~~ （这种方式会发生抖动）

```
curl -i --url http://localhost:8001/certificates \
    --data "cert='-----BEGIN CERTIFICATE-----...'" \
    --data "key='-----BEGIN RSA PRIVATE KEY-----...'" \
    --data "snis[]=prod.test.com"
```


* 为服务 `prod-service` 添加 `key-auth` 鉴权插件：

```
curl -i -X POST \
  --url http://localhost:8001/services/prod-service/plugins/ \
  --data 'name=key-auth'
```

返回类似如下：

```
{"created_at":1539931369484,"config":{"key_in_body":false,"run_on_preflight":true,"anonymous":"","hide_credentials":false,"key_names":["apikey"]},"id":"9d388bb9-818a-4349-86c0-a7e0cb182978","service_id":"0dff5819-627e-41d5-8ca0-5fa8c7362d1e","name":"key-auth","enabled":true}
```

* 添加用户，这里添加了一个用户名为 `sdk_007` 的用户：

```
curl -i -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=sdk_007"
```

返回类似如下：

```
{"custom_id":null,"created_at":1539931393,"username":"sdk_007","id":"902fa8f6-feca-4b2d-8e72-d51a86579019"}
```

* 为用户 `sdk_007` 添加用户key：

```
curl -i -X POST \
  --url http://localhost:8001/consumers/sdk_007/key-auth/
```

返回类似如下（key已修改）：

```
{"id":"1cc06dcc-0277-4154-a092-c91ff363de92","created_at":1539931418134,"key":"caQVlllch0efVNfGmidadfsa","consumer_id":"902fa8f6-feca-4b2d-8e72-d51a86579019"}
```

* 本地测试：

```
curl 'http://127.0.0.1/<API REQUEST>' --header 'Host: prod.test.com' --header 'apikey: caQVlllch0efVNfGmidadfsa'
```

* 在线测试：

使用浏览器打开 `http://prod.test.com/<API REQUEST>?apikey=caQVlllch0efVNfGmidadfsa`



## 在CentOS 7环境的部署

### 首先升级内核

（从elrepo仓库下载最新的稳定版内核，修改grub2以使用最新内核，禁用selinux，然后重启）：

```
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install -y kernel-lt

grub2-set-default 0

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

reboot
```

### 然后安装docker

```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

systemctl enable docker
systemctl start docker
```

### 启动容器

同CentOS 6.9


