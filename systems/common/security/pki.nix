# CA trust store tweaks (same option on NixOS and nix-darwin)
# On macOS this only affects the Nix bundle (/etc/ssl/certs/ca-certificates.crt,
# NIX_SSL_CERT_FILE), not the system Keychain.
{ ... }:
{
  # https://emudhra.we-have-a-problem.com/#macos-curl
  # "emSign ECC Root CA - G3" was removed upstream from NSS (3.131); listing an
  # absent cert makes the cacert build fail, so it's no longer blacklisted here.
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
  ];
}
