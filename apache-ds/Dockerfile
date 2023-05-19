FROM ubuntu:20.04
LABEL maintainer="islavka2@gmail.com"

ARG APACHE_DS_PACKAGE=apacheds-2.0.0.AM26-amd64.deb
ARG APACHE_DS_URL=https://dlcdn.apache.org//directory/apacheds/dist/2.0.0.AM26/$APACHE_DS_PACKAGE

RUN export DEBIAN_FRONTEND=noninteractive \
      && apt-get update -y \
      && apt-get install -y --no-install-recommends \
        bash \
        bc \
        coreutils \
        curl \
        debianutils \
        findutils \
        gawk \
        grep \
        libc-bin \
        mount \
        passwd \
        procps \
        rpm \
        sed \
        tar \
        util-linux \
        default-jre \
      && mkdir -p /tmp/apache \
      && cd /tmp/apache \
      && curl -LO $APACHE_DS_URL \
      && chmod +x $APACHE_DS_PACKAGE  \
      && dpkg -i $APACHE_DS_PACKAGE

CMD ["/bin/bash"]