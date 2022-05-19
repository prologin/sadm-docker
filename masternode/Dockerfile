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

RUN mkdir -p /concours  /concours/sadm

COPY sadm/requirements.txt sadm/setup.py /concours/sadm

WORKDIR /concours

# RUN chown -R concours:concours /concours/sadm

ENV CFG_DIR=/concours/config

RUN mkdir config shared

WORKDIR /concours/sadm

RUN pip install -r requirements.txt

RUN pip install aiopg==1.1.0
COPY sadm /concours/sadm

COPY masternode/masternode.yml /concours/config
RUN echo "enabled: false" > /concours/config/timeauth.yml

COPY masternode/init.sh /init.sh

ENV PYTHONUNBUFFERED=1

# RUN chown -R concours:concours /concours

CMD ["/init.sh"]
