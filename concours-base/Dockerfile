# vim: tw=2000 syntax=dockerfile

FROM archlinux:base-devel

ARG CONCOURS_UID=1000
ARG CONCOURS_GID=1000
ARG SADM_BRANCH="concours-2021"

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

USER concours

ENV CFG_DIR=/concours/config

RUN mkdir config shared concours_static

WORKDIR /concours/sadm

RUN python -m venv venv

RUN venv/bin/pip install -e . -r requirements.txt

RUN mkdir concours  && \
    cp ansible/roles/concours/templates/django/manage.py concours/manage.py

COPY concours/concours.yml /concours/config/concours.yml
COPY concours/concours-udbsync.yml /concours/config/concours-udbsync.yml

COPY concours/init.sh /init.sh

WORKDIR /concours/sadm/concours

USER root
RUN chown -R concours:concours /concours

CMD ["/init.sh"]
