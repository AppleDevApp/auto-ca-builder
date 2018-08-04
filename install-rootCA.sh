#!/bin/bash

# Import Env Config
. ./env-config

# Prepair The Path
[ -d "${CA_PATH}" ] || mkdir -p "${CA_PATH}";
[ -d "${CONFIG_PATH}" ] || mkdir -p "${CONFIG_PATH}";

# Replace Root Path With Config
cp -rf cnf/root-ca "${CONFIG_PATH}/openssl.cnf";
echo "${CONFIG_PATH}/openssl.cnf"
sed -i "s@^dir               =.*@dir               = ${CA_PATH}@" "${CONFIG_PATH}/openssl.cnf";

# Create The Root CA
cd "${CA_PATH}";
mkdir certs crl newcerts private;
chmod 700 private;
touch index.txt;
echo 1000 > serial;
openssl genrsa -aes256 -out private/ca.key.pem "${KEY_SIZE}";
chmod 400 private/ca.key.pem;
openssl req -config "${CONFIG_PATH}/openssl.cnf" \
      -key private/ca.key.pem \
      -new -x509 -days "${CA_DAYS}" -sha256 -extensions v3_ca \
      -out certs/ca.cert.pem;
chmod 444 certs/ca.cert.pem;
openssl x509 -noout -text -in certs/ca.cert.pem;
