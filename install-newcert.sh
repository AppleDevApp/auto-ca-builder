#!/bin/bash

# Import Env Config
. ./env-config

# Parse Argument
read -p "Please Input Your Cert Name: " CERT_NAME

if [ -z "${CERT_NAME}" ] ; then
  echo "CERT NAME IS NOT ALLOW EMPTY" 
  exit 1; 
fi

# Default is need encrypt
ENCRYPT_TYPE=1

while true; do
    read -p "Do you want to encrypt the cert with pwd?(y/n) " needEncrypt
    case $needEncrypt in
        [Yy]* ) ENCRYPT_TYPE=1; break;;
        [Nn]* ) ENCRYPT_TYPE=0; break;;
        * ) echo "Please answer y or n. ";;
    esac
done

echo $ENCRYPT_TYPE;
# General New Cert
cd "${CA_PATH}";

if [ $ENCRYPT_TYPE -eq 0 ]
then
   openssl genrsa \
      -out "intermediate/private/${CERT_NAME}.key.pem" "${CERT_KEY_SIZE}";
else
   openssl genrsa -aes256 \
      -out "intermediate/private/${CERT_NAME}.key.pem" "${CERT_KEY_SIZE}";
fi

chmod 400 "intermediate/private/${CERT_NAME}.key.pem";
openssl req -config "${CONFIG_MIDDLE_PATH}/openssl.cnf" \
      -key "intermediate/private/${CERT_NAME}.key.pem" \
      -new -sha256 -out "intermediate/csr/${CERT_NAME}.csr.pem";
openssl ca -config "${CONFIG_MIDDLE_PATH}/openssl.cnf" \
      -extensions server_cert -days "${CERT_DAYS}" -notext -md sha256 \
      -in "intermediate/csr/${CERT_NAME}.csr.pem" \
      -out "intermediate/certs/${CERT_NAME}.cert.pem";
chmod 444 "intermediate/certs/${CERT_NAME}.cert.pem";
openssl x509 -noout -text \
      -in "intermediate/certs/${CERT_NAME}.cert.pem";
openssl verify -CAfile "intermediate/certs/ca-chain.cert.pem" \
      "intermediate/certs/${CERT_NAME}.cert.pem";
