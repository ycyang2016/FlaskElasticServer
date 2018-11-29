FROM tiangolo/uwsgi-nginx-flask:flask-python2.7

#Install API Dependency
RUN pip install -U pip && pip install \
MySQL-python \
flask \
flask_wtf \
Flask-SQLAlchemy \
flask_httpauth \
passlib \
elasticsearch==6.3.0 \

COPY ./env_setting/nginx.config /etc/nginx/conf.d/nginx_setting.conf

CMD ["/usr/bin/supervisord"]