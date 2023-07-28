#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

mkdir /backup
mkdir /tarsnap
cd /root

# Install dependencies
apt-get update
apt-get -y install $RUN_PACKAGES $TARSNAP_MAKE_PACKAGES

echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen

# Download
wget https://pkg.tarsnap.com/tarsnap-deb-packaging-key.asc
gpg --dearmor tarsnap-deb-packaging-key.asc
mv tarsnap-deb-packaging-key.asc.gpg tarsnap-archive-keyring.gpg
mv tarsnap-archive-keyring.gpg /usr/share/keyrings/
echo "deb [signed-by=/usr/share/keyrings/tarsnap-archive-keyring.gpg] http://pkg.tarsnap.com/deb/$(lsb_release -s -c) ./" | tee -a /etc/apt/sources.list.d/tarsnap.list

curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc| gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list

apt-get update
apt-get -y install tarsnap tarsnap-archive-keyring postgresql-client-13



mv /tarsnap.conf /etc/tarsnap.conf

wget "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# Clean up
apt-get -y remove --purge $TARSNAP_MAKE_PACKAGES
apt-get -y autoremove
rm -rf /var/lib/apt/lists/*

# Self-destruct
rm "${BASH_SOURCE[0]}"