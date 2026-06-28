#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 3 - Question 10
=======================================================

Review and correct security and best-practice issues in an existing Dockerfile and Kubernetes Deployment manifest at /home/candidate/10
Do not add or remove any settings; only modify existing ones so that two settings in each file no longer pose security or best-practice concerns.
If an unprivileged user is needed for any task, use the user nobody with UID 65535.

Dokerfile

```yaml
FROM ubuntu:latest
USER root
RUN apt-get update && \
apt-get install -y --no-install-recommends \
runit=2.1.2-3ubuntu1 wget=1.17.1-1ubuntu1.5 \
chrpath=0.16-1 tdata=2020a-0ubuntu0.16.04 lsof=4.89.dfsg.0-1 \
lsb-release=9.20160110ubuntu3 sysstat=11.2.0-1ubuntu0.3 \
net-tools=1.60-26ubuntu1 numactl=2.0.11-1ubuntu1.1 bzip2=1.0.6-8.1ubuntu0.2 && \
apt-get autoremove -y && apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ARG COUCH_VERSION=6.5.1
ARG COUCH_BASE_URL=https://packages.couchbase.com/releases/6.5.1
ARG COUCH_FILE=couchbase-server-enterprise_6.5.1-ubuntu16.04_amd64.deb
ARG COUCH_SHA256=91a301f3c5e574f9c5db5ac0f13fac5dc34639f176c41f26047ee6
ENV PATH=$PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install
RUN groupadd -g 1001 cbgroup && useradd -u 1001 -g cbgroup -M cbuser
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN export INSTALL_SKIP_START=1 && \
wget -q -O ${COUCH_FILE} ${COUCH_BASE_URL}/${COUCH_FILE} && \
echo "${COUCH_SHA256}  ${COUCH_FILE}" | sha256sum -c - && \
dpkg -i ${COUCH_FILE} && \
rm -f ${COUCH_FILE}
COPY scripts/etc/service/couchbase-server/run /etc/service/couchbase-server/run
COPY scripts/dummy.sh /usr/local/bin/
COPY scripts/entrypoint.sh /
COPY scripts/bin/iptables-save /usr/local/bin/iptables-save
COPY scripts/bin/ip6tables-save /usr/local/bin/ip6tables-save
COPY scripts/bin/vidisplay /usr/local/bin/vidisplay
COPY scripts/bin/pvidisplay /usr/local/bin/pvidisplay
RUN chrpath -r "\$ORIGIN/../lib" /opt/couchbase/bin/curl
ENTRYPOINT ["/entrypoint.sh"]
USER root
CMD ["couchbase-server"]
EXPOSE 8091-8096 11210 11211 18091-18096
VOLUME /opt/couchbase/var
```

Deployment manifest

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
name: mysql-db
labels:
app: mysql-db
spec:
replicas: 1
selector:
matchLabels:
app: mysql-db
template:
metadata:
labels:
app: mysql-db
spec:
containers:
- name: mysql-container
image: mysql:5.1
resources:
requests:
cpu: "1"
memory: 512Mi
limits:
cpu: "2"
memory: 1Gi
securityContext:
runAsUser: 0
privileged: false
readOnlyRootFilesystem: true
capabilities:
add: ["NET_BIND_SERVICE"]
drop: ["ALL"]
env:
- name: MYSQL_PASSWORD
value: "mydbpassword"
volumes:
- name: db-storage
emptyDir: {}
```

=======================================================
EOF
