# vim: tw=2000 syntax=dockerfile

FROM archlinux:base-devel

ARG CONCOURS_UID=1000
ARG CONCOURS_GID=1000

RUN pacman -Sy --noconfirm \
    python \
    python-pip \
    postgresql-libs \
    git \
    libxslt \
    libyaml \
    python-setuptools \
    python-virtualenv && \
    rm -rf /var/cache/pacman/*

RUN mkdir -p /concours && \
    groupadd -g ${CONCOURS_GID} concours && \
    useradd -u ${CONCOURS_UID} -g concours -d /concours -s /bin/bash concours && \
    chown -R concours:concours /concours

WORKDIR /concours

COPY sadm /concours/sadm
RUN chown -R concours:concours /concours/sadm

ENV CFG_DIR=/concours/config

RUN mkdir config shared

WORKDIR /concours/sadm

RUN pip install -e . -r requirements.txt

RUN pip install aiopg==1.1.0

COPY masternode/masternode.yml /concours/config

COPY masternode/init.sh /init.sh

RUN chown -R concours:concours /concours

USER concours

CMD ["/init.sh"]
