FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
      bzip2 \
      gcc \
      curl \
      libssl-dev \
      build-essential

RUN curl -L https://github.com/squid-cache/squid/releases/download/SQUID_6_12/squid-6.12.tar.bz2 -o squid.tar.bz2

RUN tar -jxf ./squid.tar.bz2 -C /tmp

WORKDIR /tmp/squid-6.12

RUN ls /tmp/squid-6.12 

RUN ./configure \
            --prefix=/usr \
            --localstatedir=/var \
            --libexecdir=${prefix}/lib/squid \
            --datadir=${prefix}/share/squid \
            --sysconfdir=/etc/squid \
            --with-default-user=proxy \
            --with-logdir=/var/log/squid \
            --with-pidfile=/var/run/squid.pid \
            --with-openssl

RUN make

RUN make install #

RUN make -p /etc/squid

RUN chown proxy:proxy /var/log/squid

COPY ./squid.conf /etc/squid/squid.conf

CMD ["/usr/sbin/squid", "--foreground"]
