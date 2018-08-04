# auto-ca-builder

Auto create ssl ca cetificate authority

## Usage

Download the code:

```bash
cd auto-ca-builder;
chmod +x *.sh;
```

Defatult install path: `/data/ssl/cert/ca`, you can replace it by modify the env-config file.

```config

# Root CA Config
CERT_PATH=/data/sslcert
CA_PATH="${CERT_PATH}/ca"
CONFIG_PATH="${CERT_PATH}/config"
CA_DAYS=7300
KEY_SIZE=4096

# Middle CA Config
CA_MIDDLE_PATH="${CA_PATH}/intermediate"
CONFIG_MIDDLE_PATH="${CONFIG_PATH}/intermediate"
CA_MIDDLE_DAYS=3650

# SERVER/CLIENT CERT CONFIG
CERT_DAYS=375
CERT_KEY_SIZE=2048

```

```execute command

# create ca
./install-rootCA.sh
./install-intermediateCA.sh

# general cert
./install-newcert.sh
```

## use

download the ca-cert.pem,ca-chain.cert.pem file to your computer 
and install it by double click and make it trust by your computer.
