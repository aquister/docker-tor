FROM ubuntu:16.04

ENV container docker
ENV TERM xterm
ENV TORNAME tor-0.3.2.5-alpha

WORKDIR /tmp

RUN set -eux \
    && buildDeps='libwww-perl build-essential libevent-dev libssl-dev wget vim curl net-tools python3-pip' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && wget -q https://www.torproject.org/dist/${TORNAME}.tar.gz.asc \
    && wget -q https://www.torproject.org/dist/${TORNAME}.tar.gz \
    && gpg --keyserver pool.sks-keyservers.net --recv-keys 0x28988BF5 \
    && gpg --keyserver pool.sks-keyservers.net --recv-keys 0x19F78451 \
    && gpg --keyserver pool.sks-keyservers.net --recv-keys 0xFE43009C4607B1FB \
    && gpg --keyserver pool.sks-keyservers.net --recv-keys 0x6AFEE6D49E92B601 \
    && gpg --verify ${TORNAME}.tar.gz.asc ${TORNAME}.tar.gz \
    && tar xzf ${TORNAME}.tar.gz \
    && ( cd ${TORNAME} \
        && ./configure \
        && make -j4 \
        && make install ) \
    && rm -rf ${TORNAME} \
    && apt-get autoremove --purge -y build-essential \
    && pip3 install nyx \
    && apt-get clean

COPY torrc /etc/torrc

#EXPOSE 9050
EXPOSE 80

CMD ["/usr/local/bin/tor", "-f", "/etc/torrc"]
