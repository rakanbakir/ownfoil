FROM python:3.10.14-alpine3.20

RUN mkdir /app

COPY ./app /app
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

RUN pip3 install --upgrade pip
RUN apk upgrade busybox

RUN apk add --update --no-cache bash nginx apache2-utils sudo

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && rm /tmp/requirements.txt

RUN set -e \
      && ln -sf /dev/stdout /var/log/nginx/access.log \
      && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80
ENTRYPOINT [ "/app/run.sh" ]