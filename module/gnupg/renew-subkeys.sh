#!/usr/bin/env bash
set -ex
mkdir -p /tmp/to-remove

pushd /tmp/to-remove

tar xvzf /tmp/gpg-master.tar.gz

export GNUPGHOME=/tmp/to-remove/tmp/tmp.pChFElULG1
cd ${GNUPGHOME}

# fix pinentry
sed -i "s|^\(pinentry-program\).*$|\1 $(realpath $(which pinentry))|g" $GNUPGHOME/gpg-agent.conf

export KEYID=0xB151572DE8FADB71
# You can get the KEYID through gpg -k (sec   rsa4096/0xB151572DE8FADB71 2020-12-14 [C])
# You can also get it through gpg --card-status (shall be the one with expires: never)

cat << EOF
Select all expired keys:
gpg> key 1

gpg> key 2

gpg> key 3
sec  rsa4096/0xF0F2CFEB04341FB5
     created: 2024-01-01  expires: never       usage: C
     trust: ultimate      validity: ultimate
ssb* rsa4096/0xB3CD10E502E19637
     created: 2024-01-01  expires: 2026-01-01  usage: S
ssb* rsa4096/0x30CBE8C4B085B9F7
     created: 2024-01-01  expires: 2026-01-01  usage: E
ssb* rsa4096/0xAD9E24E1B8CB9600
     created: 2024-01-01  expires: 2026-01-01  usage: A
[ultimate] (1). YubiKey User <yubikey@example>

Use 'expire' to configure the expiration date. This will not expire valid keys.

Set the expiration date, then: 'save'
EOF

echo "copy your gpg key password now ! (If you know it)\n
then press enter to pursue)"
read blah
gpg --edit-key $KEYID

popd
# Next, Export public keys:
gpg --armor --export $KEYID > module/gnupg/gpg-$KEYID-$(date +%F).asc
