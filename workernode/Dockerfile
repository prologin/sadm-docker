# vim: tw=2000 syntax=dockerfile

FROM archlinux:base-devel

RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN printf 'LANG=en_US.UTF-8\n' > /etc/locale.conf && locale-gen


# Install languages dependencies
RUN pacman -Sy --noconfirm \
    gcc \
    zeromq \
    make \
    gtest \
    python-yaml \
    python-jinja \
    gflags \
    gc \
    git \
    pkg-config \
    python-pip \
    gcc \
    ghc \
    jdk-openjdk \
    mono \
    ocaml \
    php \
    php-embed \
    rust && \
    rm -rf /var/cache/pacman/pkg/*

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

# install isolate
COPY workernode/isolate.tar.zst /tmp/isolate.tar.zst
RUN pacman -U /tmp/isolate.tar.zst --noconfirm && \
    rm /tmp/isolate.tar.zst


# install stechec2
RUN git clone -b nix-stechec https://github.com/prologin/stechec2.git /stechec2 && \
    cd /stechec2 && \
    ./waf.py configure --prefix=/usr && \
    ./waf.py build install

# install sadm
RUN mkdir -p /config /sadm
COPY sadm/requirements.txt sadm/setup.py /sadm
RUN pip install -r /sadm/requirements.txt
COPY sadm/ /sadm
WORKDIR /sadm
COPY workernode/workernode.yml /config/workernode_base.yml
RUN echo "enabled: true" > /config/timeauth.yml
ENV CFG_DIR=/config
COPY workernode/init.sh /init.sh

CMD [ "/init.sh" ]

