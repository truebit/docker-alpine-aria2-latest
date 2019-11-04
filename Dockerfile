FROM alpine:edge
LABEL AUTHOR="Xiao Wang <wangxiao8611@gmail.com>"

WORKDIR /app

ENV ENABLE_AUTH=false
ENV ARIA2_USER=user
ENV ARIA2_PWD=password
ENV RPC_SECRET=""
ENV RPC_SECURE=false
ENV UID=1000
ENV GID=1000

#sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
RUN apk update \
    && apk add --no-cache --virtual .build_deps g++ autoconf make automake libtool cppunit-dev curl \
    && apk add --no-cache su-exec shadow nettle-dev gmp-dev libssh2-dev libxml2-dev zlib-dev gnutls-dev gettext-dev sqlite-dev c-ares-dev  \
    && cd /tmp \
    && curl -fSL https://github.com/aria2/aria2/archive/master.zip -o aria2-master.zip \
    && unzip aria2-master.zip \
    && cd aria2-master \
    && sed -i 's/1.35.0/1.35.0master/g' configure.ac \
    && autoreconf -i \
    && ./configure \
    && make -j $(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build_deps \
    && rm -r /tmp/* \
    #增加用户与组：aria2
    && addgroup -g "$GID" aria2 \
    && adduser -D -G aria2 -u "$UID" aria2

#SSL证书
VOLUME /app/conf/key
#下载文件夹；请在宿主机中配置UID和GID相关的访问权限
VOLUME /data

COPY conf /app/conf
COPY entry_point.sh /

ENTRYPOINT [ "/entry_point.sh" ]

EXPOSE 6800

CMD [ "aria2c" ] 
