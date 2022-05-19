#! /bin/sh

envsubst < /config/workernode_base.yml > /config/workernode.yml

export JAVA_HOME=/usr/lib/jvm/default

cd /sadm

if [ "$WORKERNODE_DEBUG" -eq 1 ]; then
  exec python -m prologin.workernode -l -v
else
  exec python -m prologin.workernode -l
fi
