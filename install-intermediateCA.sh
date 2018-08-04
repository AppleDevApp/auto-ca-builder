#!/bin/bash

# Import Env Config
. ./env-config

# Prepair The Path
[ -d "${CA_MIDDLE_PATH}" ] || mkdir -p "${CA_MIDDLE_PATH}";
[ -d "${CONFIG_MIDDLE_PATH}" ] || mkdir -p "${CONFIG_MIDDLE_PATH}";

# Replace Root Path With Config
cp -rf cnf/intermediate-ca "${CONFIG_MIDDLE_PATH}/openssl.cnf";
echo "${CONFIG_MIDDLE_PATH}/openssl.cnf"
sed -i "s@^dir               =.*@dir               = ${CA_MIDDLE_PATH}@" "${CONFIG_MIDDLE_PATH}/openssl.cnf";


# Create The Root CA
cd "${CA_MIDDLE_PATH}";
mkdir certs crl csr newcerts private;
chmod 700 private;
touch index.txt;
echo 1000 > serial;
echo 1000 > "${CA_MIDDLE_PATH}/crlnumber";

# General Middle CA
cd "${CA_PATH}";
openssl genrsa -aes256 \
      -out intermediate/private/intermediate.key.pem "${KEY_SIZE}";
chmod 400 intermediate/private/intermediate.key.pem;
openssl req -config "${CONFIG_MIDDLE_PATH}/openssl.cnf" -new -sha256 \
      -key intermediate/private/intermediate.key.pem \
      -out intermediate/csr/intermediate.csr.pem;
openssl ca -config "${CONFIG_PATH}/openssl.cnf" -extensions v3_intermediate_ca \
      -days "${CA_MIDDLE_DAYS}" -notext -md sha256 \
      -in intermediate/csr/intermediate.csr.pem \
      -out intermediate/certs/intermediate.cert.pem;
chmod 444 intermediate/certs/intermediate.cert.pem;
openssl x509 -noout -text \
      -in intermediate/certs/intermediate.cert.pem;
openssl verify -CAfile certs/ca.cert.pem \
      intermediate/certs/intermediate.cert.pem;
cat intermediate/certs/intermediate.cert.pem \
      certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem;
chmod 444 intermediate/certs/ca-chain.cert.pem;
