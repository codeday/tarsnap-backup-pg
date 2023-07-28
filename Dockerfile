FROM debian:buster

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e \
    TARSNAP_MAKE_PACKAGES="wget curl ca-certificates lsb-release gpg" \
    RUN_PACKAGES="locales openssl"

COPY . /
RUN /install.sh

CMD /startup.sh