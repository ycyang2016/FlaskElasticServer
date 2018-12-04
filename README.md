# 簡介
內含用docker環境來部署一個用python實作的flask api server及elasticsearch的系統
# 基本環境
### 作業系統：
* Ubuntu 16.04
* MAC OS 10.14.1
### 需求套件：
* pip 18.1
* python 2.7 or python 3.6
* docker 18.06.1-ce
* docker-compose 1.22.0
# 安裝環境
### python & pip
> 請參考[在Ubuntu上如何安装最新的Python 2.7.X或3.X？](https://vimsky.com/article/3577.html)
### docker
> 請參考[Ubuntu 16.04安裝 | docker](https://zouyapeng.gitbooks.io/docker/content/DockerInstallation/ubuntu_16_04.html)
### docker-compose
`sudo pip install docker-compose`
# 快速安裝
### 下載安裝包
`git clone https://github.com/ycyang2016/FlaskElasticServer my_application`
### 啟動系統
```
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w vm.overcommit_memory=1
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
sudo echo never > /sys/kernel/mm/transparent_hugepage/defrag
cd my_application
docker-compose up -d
```
# 設定檔
### docker-compose.yml
* container
  ```
  1. 三個 elasticsearch 6.5 的節點
  2. 一個 elasticsearch 介面(KOPF)
  3. Flask api server
  4. Mysql 8.0
  5. redis 5.0.2
  ```
* networks and ports
  ```
  1. KOPF 使用 port 9000
  2. Flask api server 使用 port 5000
  ```
* volumes
  ```
  1. elasticsearch 的節點、mysql、redis皆使用 local volume，若有需求可自行導到外部的資料夾上
  2. KOPF 的設定檔存放在 my_application/env_setting/kopf.config 中
  3. Flask api server 的程式碼存放在 my_application/source_code 中
  ```
* environment
  ```
  general:
  1. TZ=Asia/Taipei：將時間設定為UTC+8
  ```
  ```
  elasticsearch:
  1. cluster.name=docker-cluster：所有的節點叢集名稱必須相同
  2. node.name=es1：節點名稱
  3. bootstrap.memory_lock=true：重新啟動時比較不會crash
  4. "ES_JAVA_OPTS=-Xms512m -Xmx512m"：設定記憶體限制，預設為2G
  5. "discovery.zen.minimum_master_nodes=2"：設定主節點數量，一般會大於2，但只有節點數小於2時需為1
  6. "discovery.zen.ping.unicast.hosts=elasticsearch2,elasticsearch3"：其他節點的IP位置，無須列出所有節點
  ```
  ```
  mysql:
  1. MYSQL_ROOT_PASSWORD: root的密碼，請修改
  2. MYSQL_ALLOW_EMPTY_PASSWORD: 是否允許root無密碼登入
  
  注意：環境變數在沒有任何資料庫存在時，才會生效，更多的環境變數可參考底下的 mysql-docker 連結
  ```
  ```
  redis:
  1. ALLOW_EMPTY_PASSWORD: 是否允許無密碼登入
  ```
* command
  ```
  mysql:
  1. --default-authentication-plugin=mysql_native_password：預設使用傳統mysql的加密方式，若想使用新版的請移除command
  ```
### Flask api server dockerfile
* 位置：my_application/env_setting/api_server
* 環境：uwsgi+nginx+python2.7
* uwsgi設定檔位置：my_application/source_code/uwsgi.ini
* nginx設定檔位置：my_application/env_setting/nginx.config
* redis設定檔位置：my_application/env_setting/redis.config
* python套件：
  ```
  1. MySQL-python
  2. flask
  3. flask_wtf
  4. Flask-SQLAlchemy
  5. flask_httpauth
  6. passlib
  7. elasticsearch
  8. redis
  ```
# 連結
* [docker](https://docs.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)
* [elasticsearch docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
* [elasticsearch kopf](https://github.com/lmenezes/cerebro)
* [uwsgi](https://uwsgi-docs.readthedocs.io/en/latest/)
* [nginx](https://unit.nginx.org/)
* [flask](http://flask.pocoo.org/)
* [redis](https://redis-py.readthedocs.io/en/latest/)
* [mysql](https://dev.mysql.com/doc/relnotes/mysql/8.0/en/news-8-0-13.html)]
* [mysql-docker](http://blog.51cto.com/aaronsa/2133984)
