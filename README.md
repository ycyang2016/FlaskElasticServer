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
`git clone https://github.com/ycyang2016/FlaskElasticServe my_application`
### 啟動系統
```
sudo sysctl -w vm.max_map_count=262144
cd my_application
docker-compose up -d
```
# 設定檔
### docker-compose.yml
* container
  ```
  三個 elasticsearch 的節點、一個 elasticsearch 介面(KOPF)及 Flask api server
  ```
* networks and ports
  ```
  1. KOPF 使用 port 9000
  2. Flask api server 使用 port 5000
  ```
* volumes
  ```
  1. elasticsearch 的節點皆使用 local volume，若有需求可自行導到外部的資料夾上
  2. KOPF 的設定檔存放在 my_application/env_setting/kopf.config 中
  3. Flask api server 的程式碼存放在 my_application/source_code 中
  ```
* environment
  ```
  TZ=Asia/Taipei：將時間設定為UTC+8
  ```
* command
  ```
  1. cluster.name=docker-cluster：所有的節點叢集名稱必須相同
  2. node.name=es1：節點名稱
  3. bootstrap.memory_lock=true：重新啟動時比較不會crash
  4. "ES_JAVA_OPTS=-Xms512m -Xmx512m"：設定記憶體限制，預設為2G
  5. "discovery.zen.minimum_master_nodes=2"：設定主節點數量，一般會大於2，但只有節點數小於2時需為1
  6. "discovery.zen.ping.unicast.hosts=elasticsearch2,elasticsearch3"：其他節點的IP位置，無須列出所有節點
  ```
### Flask api server dockerfile
* 位置：my_application/env_setting/api_server
* 環境：uwsgi+nginx+python2.7
* uwsgi設定檔位置：my_application/source_code/uwsgi.ini
* nginx設定檔位置：my_application/env_setting/nginx.config
* python套件：
  ```
  1. MySQL-python
  2. flask
  3. flask_wtf
  4. Flask-SQLAlchemy
  5. flask_httpauth
  6. passlib
  7. elasticsearch
  ```
# 連結
* [docker](https://docs.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)
* [elasticsearch docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
* [elasticsearch kopf](https://github.com/lmenezes/cerebro)
* [uwsgi](https://uwsgi-docs.readthedocs.io/en/latest/)
* [nginx](https://unit.nginx.org/)
* [flask](http://flask.pocoo.org/)
