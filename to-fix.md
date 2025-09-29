1. something is odd with Yubikeys (desktop manager does not find my Yubikeys)
here is the error log.
18:15:23.912 [helper] ERROR: Traceback (most recent call last):
18:15:23.912 [helper] ERROR:   File "/nix/store/1mj8ybxbgx1zf0im090czcrszqmaqnb4-yubioath-flutter-helper-7.2.3/bin/.authenticator-helper-wrapped", line 18, in <module>
18:15:23.912 [helper] ERROR:     from helper import run_rpc_pipes, run_rpc_socket
18:15:23.912 [helper] ERROR:   File "/nix/store/1mj8ybxbgx1zf0im090czcrszqmaqnb4-yubioath-flutter-helper-7.2.3/lib/python3.13/site-packages/helper/__init__.py", line 16, in <module>
18:15:23.912 [helper] ERROR:     from .device import RootNode
18:15:23.912 [helper] ERROR:   File "/nix/store/1mj8ybxbgx1zf0im090czcrszqmaqnb4-yubioath-flutter-helper-7.2.3/lib/python3.13/site-packages/helper/device.py", line 24, in <module>
18:15:23.913 [helper] ERROR:     from .fido import Ctap2Node
18:15:23.913 [helper] ERROR:   File "/nix/store/1mj8ybxbgx1zf0im090czcrszqmaqnb4-yubioath-flutter-helper-7.2.3/lib/python3.13/site-packages/helper/fido.py", line 30, in <module>
18:15:23.913 [helper] ERROR:     from ykman.hid import list_ctap_devices as list_ctap
18:15:23.913 [helper] ERROR:   File "/nix/store/3m8qzkq8q45kqai8fnhnzs5bv5dx8z6d-python3.13-yubikey-manager-5.8.0/lib/python3.13/site-packages/ykman/hid/__init__.py", line 38, in <module>
18:15:23.913 [helper] ERROR:     from .fido import list_ctap_devices
18:15:23.913 [helper] ERROR:   File "/nix/store/3m8qzkq8q45kqai8fnhnzs5bv5dx8z6d-python3.13-yubikey-manager-5.8.0/lib/python3.13/site-packages/ykman/hid/fido.py", line 9, in <module>
18:15:23.913 [helper] ERROR:     from ..device import YkmanDevice
18:15:23.913 [helper] ERROR:   File "/nix/store/3m8qzkq8q45kqai8fnhnzs5bv5dx8z6d-python3.13-yubikey-manager-5.8.0/lib/python3.13/site-packages/ykman/device.py", line 48, in <module>
18:15:23.913 [helper] ERROR:     from .hid import (
18:15:23.913 [helper] ERROR:         list_ctap_devices as _list_ctap_devices,
18:15:23.913 [helper] ERROR:     )
18:15:23.913 [helper] ERROR: ImportError: cannot import name 'list_ctap_devices' from partially initialized module 'ykman.hid' (most likely due to a circular import) (/nix/store/3m8qzkq8q45kqai8fnhnzs5bv5dx8z6d-python3.13-yubikey-manager-5.8.0/lib/python3.13/site-packages/ykman/hid/__init__.py)
18:15:42.685 [desktop.init] INFO: Copying log to clipboard (7.2.3)...

Seems to be fixed in the next yubikey-manager release cf: https://github.com/nixos/nixpkgs/issues/442315


