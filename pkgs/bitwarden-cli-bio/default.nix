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
    rev = "f35f5a632ba7f9d50243a2b80233d30a020eec76";
    hash = "sha256-U7h/oT08Z9w12bWClk2cT61s+TXIGeiWGMFBAkazuGk=";
  };
  npmDepsHash = "sha256-ITJcoBaKosnhRleLp8b5+W5WJ3aI3GFYt4KPPlghsyM=";
  npmBuildScript = "build";
}
