{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

# Bitwarden CLI wrapper with biometric unlock support (Touch ID / Windows Hello)
# Pinned to braumye's fork while PR for the IPC connection race-condition fix
# is pending upstream (jeanregisser/bitwarden-cli-bio). Revert to jeanregisser
# + v1.4.3 tag once merged and released.
buildNpmPackage {
  pname = "bitwarden-cli-bio";
  version = "1.4.2-ipc-race-fix";
  src = fetchFromGitHub {
    owner = "braumye";
    repo = "bitwarden-cli-bio";
    rev = "71e600af3aaef45f022070f181fc2bc9ad7d57ab";
    hash = "sha256-mDavFl38+lGBDJMoieY5VXtsR3E41zCQwmyBi3Da9yo=";
  };
  npmDepsHash = "sha256-ITJcoBaKosnhRleLp8b5+W5WJ3aI3GFYt4KPPlghsyM=";
  npmBuildScript = "build";
}
