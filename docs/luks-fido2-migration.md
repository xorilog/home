# nixophe: LUKS Yubikey challenge-response → FIDO2 migration

nixpkgs (26.11) removed the scripted stage 1 initrd, and with it
`boot.initrd.luks.yubikeySupport` / `devices.<name>.yubikey`. nixophe's root
volume was unlocked with that scheme (Yubikey slot 2 HMAC challenge-response,
salt stored on `/dev/nvme0n1p1`, two-factor with a passphrase).

`systems/nixophe/boot.nix` now uses the systemd initrd with
`crypttabExtraOpts = [ "fido2-device=auto" ]`. **The new generation will only
unlock the disk once a FIDO2 keyslot (or a passphrase keyslot) has been enrolled.**
Do the steps below on nixophe, booted on the *current* (old) generation, *before*
`make switch`.

```sh
DEV=/dev/disk/by-uuid/abbdad3e-93b4-4b6e-989f-8fb8dda493b1
```

## 0. Safety net

- The old generations stay in the systemd-boot menu: if the new one can't
  unlock, reboot and pick the previous entry (its initrd still has the
  challenge-response unlock). **Don't `nix-collect-garbage -d` / `make clean`
  until the new generation has booted successfully.**
- Don't touch the existing Yubikey keyslot until the end (step 6).

## 1. Inspect the volume

```sh
sudo cryptsetup luksDump "$DEV" | grep -E '^Version|Keyslots|^  [0-9]+: luks2|^Key Slot'
```

- Note the **version** and which **keyslots** are in use.
- `systemd-cryptenroll` (FIDO2) needs **LUKS2**. If it says `Version: 1`, see
  [Appendix: LUKS1](#appendix-luks1-volume).

## 2. Recover the current key (if you have no plain passphrase slot)

If you already have a recovery passphrase that opens the disk, skip to step 3.

The old initrd derived the LUKS key as:

```
salt, iterations = lines 1-2 of /crypt-storage/default on nvme0n1p1
challenge        = hex(sha512(salt))
response         = ykchalresp -2 -x challenge           (hex)
key              = PBKDF2-HMAC-SHA512(passphrase, unhex(response), iterations, 64 bytes)
```

Reproduce it (Yubikey plugged in; type the same passphrase you type at boot):

```sh
# nvme0n1p1 is the ESP, mounted on /boot
ls /boot/crypt-storage/default

umask 077
nix shell nixpkgs#python3 nixpkgs#yubikey-personalization -c python3 -I - \
  /boot/crypt-storage/default > /run/user/$UID/old-luks.key <<'EOF'
import getpass, hashlib, subprocess, sys
salt, iterations = open(sys.argv[1]).read().split("\n")[:2]
challenge = hashlib.sha512(salt.strip().encode()).hexdigest()
response = subprocess.check_output(["ykchalresp", "-2", "-x", challenge]).decode().strip()
# the old initrd did `echo -n $k_user` unquoted: runs of whitespace collapse to one space
passphrase = " ".join(getpass.getpass("LUKS passphrase: ").split()).encode()
sys.stdout.buffer.write(hashlib.pbkdf2_hmac("sha512", passphrase, bytes.fromhex(response), int(iterations), 64))
EOF

# must say nothing and exit 0
sudo cryptsetup open --test-passphrase --key-file /run/user/$UID/old-luks.key "$DEV" && echo OK
```

> Valid for nixophe's config (`twoFactor = true`, `keyLength = 64`, slot 2).
> If the passphrase contains glob characters (`*`, `?`, `[`), the old unquoted
> `echo -n $k_user` may have expanded them. Try the literal first.

## 3. Add a recovery passphrase

Keep this one in Bitwarden, since it's the fallback when no Yubikey is around.

```sh
sudo cryptsetup luksAddKey --key-file /run/user/$UID/old-luks.key "$DEV"
# (or, if you already had a passphrase slot: sudo cryptsetup luksAddKey "$DEV")
sudo cryptsetup open --test-passphrase "$DEV" && echo OK   # test the new passphrase
```

## 4. Enroll the Yubikey(s) as FIDO2

One per key (yubikey-5-usbc-989, yubikey-5-usba-955, yubikey-5-usbc-jt-892…),
plugging them in one at a time. It asks for an existing passphrase (use the
recovery one), then the FIDO2 PIN, then a touch.

```sh
sudo systemd-cryptenroll --fido2-device=auto "$DEV"
# defaults: PIN required + touch required. To drop the PIN:
#   --fido2-with-client-pin=no
```

If the key has no FIDO2 PIN yet: `ykman fido access change-pin`.

Check: `sudo systemd-cryptenroll "$DEV"` lists `fido2` slot(s) plus `password`.

## 5. Switch and reboot

```sh
make switch
reboot
```

At boot, the systemd initrd asks you to touch the key (and the PIN). Without a
key, it falls back to the passphrase prompt. If something goes wrong, pick the
previous generation in the systemd-boot menu.

## 6. Clean up (once the new generation boots fine)

```sh
shred -u /run/user/$UID/old-luks.key 2>/dev/null; true
# remove the old challenge-response keyslot (its number from step 1)
sudo cryptsetup luksKillSlot "$DEV" <old-slot>
# the salt file isn't used anymore
sudo rm -r /boot/crypt-storage
```

Slot 2 HMAC config on the Yubikeys can stay (harmless) or be wiped with
`ykman otp delete 2`.

## Appendix: LUKS1 volume

`systemd-cryptenroll` refuses LUKS1. Conversion has to be done **offline**
(boot a NixOS live USB), and needs a free ~16 MiB of header space (default on
cryptsetup ≥ 2):

```sh
sudo cryptsetup convert --type luks2 "$DEV"
sudo cryptsetup luksConvertKey --pbkdf argon2id "$DEV"   # per passphrase slot
```

Do step 2-3 *before* that (from the running system), so you have a plain
passphrase to work with on the live USB. Then reboot into the old generation and
continue at step 4. Back up the header first:
`sudo cryptsetup luksHeaderBackup "$DEV" --header-backup-file luks-header.img`
(store it off-disk).
