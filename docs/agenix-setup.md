# Agenix Setup and Usage Guide

This guide explains how to set up and use agenix for secrets management in this NixOS configuration.

## Overview

Agenix is a tool for managing secrets in NixOS using age encryption. It encrypts secrets with public keys and decrypts them at system build/activation time.

## Prerequisites

1. **SSH Key Pair**: You need an Ed25519 SSH key pair
2. **Host SSH Keys**: Your NixOS machine needs SSH host keys

## Initial Setup

### 1. Generate SSH Keys (if not already present)

```bash
# User SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your-email@example.com"

# Get your public key
cat ~/.ssh/id_ed25519.pub
```

### 2. Get Host SSH Keys

```bash
# Get your machine's SSH host key
sudo cat /etc/ssh/ssh_host_ed25519_key.pub
```

### 3. Update secrets.nix

Edit `/secrets.nix` and replace the placeholder keys with your real keys:

```nix
let
  # Your user SSH public key
  xophe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIYourActualPublicKeyHere...";

  # Your machine's SSH host public key
  nixophe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIYourMachinePublicKeyHere...";

  users = [ xophe ];
  systems = [ nixophe ];
  all = users ++ systems;
in
{
  "atuin-key.age".publicKeys = [ xophe nixophe ];
  # Add more secrets as needed
}
```

## Creating and Managing Secrets

### 1. Create a Secret File

```bash
# Create and edit a secret (this will open your $EDITOR)
agenix -e atuin-key.age

# The secret will be encrypted and stored as secrets/atuin-key.age
```

### 2. Enable the Secret in Configuration

Edit `systems/common/programs/agenix.nix` and uncomment/add your secret:

```nix
{ config, lib, pkgs, ... }:
{
  age = {
    identityPaths = [ "/home/xophe/.ssh/id_ed25519" ];
    secrets = {
      atuin-key = {
        file = ../../secrets/atuin-key.age;
        owner = "xophe";
        group = "users";
        mode = "0400";
      };
    };
  };
}
```

### 3. Rebuild and Deploy

```bash
# Rebuild your system
sudo nixos-rebuild switch --flake .

# The secret will be decrypted to /run/agenix/atuin-key
```

## Available Secrets Integration

### Atuin Shell History Sync

The atuin configuration is already set up to use agenix secrets:

1. Create your atuin sync key: `agenix -e atuin-key.age`
2. Enable it in `agenix.nix` (uncomment the atuin-key section)
3. Rebuild your system

The key will be automatically placed in the correct location for atuin.

## Common Operations

### List Secrets

```bash
# List all defined secrets
agenix -l
```

### Edit Existing Secret

```bash
# Edit an existing secret
agenix -e atuin-key.age
```

### Re-key Secrets (when keys change)

```bash
# Re-encrypt all secrets with new keys (after updating secrets.nix)
agenix -r
```

### View Secret (decrypted)

```bash
# View decrypted secret content
agenix -d atuin-key.age
```

## File Structure

```
/home/xophe/src/github.com/xorilog/home/
├── secrets.nix                           # Public keys and secret definitions
├── secrets/                              # Encrypted secret files (created by agenix)
│   ├── atuin-key.age
│   └── ...
├── systems/common/programs/agenix.nix    # Agenix configuration
└── docs/agenix-setup.md                  # This guide
```

## Security Best Practices

1. **Backup your SSH keys**: Store them securely
2. **Never commit unencrypted secrets**: Only `.age` files should be in git
3. **Use different keys per environment**: Consider separate keys for dev/prod
4. **Regular key rotation**: Periodically rotate secrets and keys
5. **Minimal access**: Only give access to users/machines that need it

## Troubleshooting

### Secret not decrypting

1. Check that your SSH key path is correct in `agenix.nix`
2. Verify your public key is listed in `secrets.nix`
3. Ensure the secret was encrypted with the correct keys

### Permission errors

1. Check owner/group/mode settings in `agenix.nix`
2. Verify the target user exists

### Build errors

```bash
# Check agenix configuration
nix build .#nixosConfigurations.nixophe.config.system.build.toplevel

# Verify secret syntax
agenix -l
```

## Adding New Secrets

1. Add secret definition to `secrets.nix`
2. Create the secret: `agenix -e newsecret.age`
3. Add configuration to `agenix.nix`
4. Reference in your NixOS modules as `/run/agenix/newsecret`
5. Rebuild system

## Integration Examples

### SSH Private Key

```nix
# In secrets.nix
"ssh-deploy-key.age".publicKeys = all;

# In agenix.nix
ssh-deploy-key = {
  file = ../../secrets/ssh-deploy-key.age;
  owner = "xophe";
  group = "users";
  mode = "0600";
};

# Usage in configuration
home.file.".ssh/deploy_key" = {
  source = "/run/agenix/ssh-deploy-key";
};
```

### API Token

```nix
# In secrets.nix
"api-token.age".publicKeys = [ xophe nixophe ];

# In agenix.nix
api-token = {
  file = ../../secrets/api-token.age;
  owner = "root";
  group = "root";
  mode = "0400";
};

# Usage in service
systemd.services.myservice.environment.API_TOKEN =
  builtins.readFile "/run/agenix/api-token";
```

## See Also

- [Agenix Documentation](https://github.com/ryantm/agenix)
- [Age Encryption Specification](https://age-encryption.org/)
- [NixOS Manual - Secrets Management](https://nixos.org/manual/nixos/stable/index.html#sec-secrets)
