#! /bin/sh

envsubst < /config/workernode_base.yml > /config/workernode.yml

export JAVA_HOME=/usr/lib/jvm/default

cd /sadm

exec python -m prologin.workernode -l -v
