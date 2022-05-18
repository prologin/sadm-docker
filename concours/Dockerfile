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

RUN mkdir -p /concours/sadm
COPY sadm/requirements.txt sadm/setup.py /concours/sadm

WORKDIR /concours/sadm

RUN python -m venv venv

RUN venv/bin/pip install -r requirements.txt

COPY sadm /concours/sadm
RUN venv/bin/pip install .
#RUN chown -R concours:concours /concours/sadm

ENV CFG_DIR=/concours/config

RUN mkdir /concours/config /concours/shared /concours/concours_static /concours/concours

RUN cp /concours/sadm/ansible/roles/concours/templates/django/manage.py /concours/concours/manage.py

COPY concours/concours.yml /concours/config/concours.yml
COPY concours/concours-udbsync.yml /concours/config/concours-udbsync.yml

RUN echo "enabled: true" > /concours/config/timeauth.yml

COPY concours/init.sh /init.sh

WORKDIR /concours/sadm

# USER root

COPY concours/finale_game /concours/finale_game

# RUN chown -R concours:concours /concours

CMD ["/init.sh"]
