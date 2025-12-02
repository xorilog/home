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


2. Docker issue with networking.
  The root issue is that your system's netfilter/iptables kernel modules aren't loaded

Temporary Fix: with 2 steps (need to evaluate if all are required)
  a. set back userland-proxy = false.
  b. loaded the following modules: (I need to ensure they are required or not and if they where removed from a previous configuration.)
    - sudo modprobe iptable_nat
    - sudo modprobe iptable_filter
    - sudo modprobe iptable_mangle

Extraction of the modules: `lsmod | grep iptable`
Here is the content of the module check before activating:

Here is the content of the module check after activating:
iptable_mangle         12288  0
iptable_filter         12288  1
iptable_nat            12288  1
ip_tables              28672  3 iptable_filter,iptable_nat,iptable_mangle
x_tables               53248  18 xt_conntrack,iptable_filter,nft_compat,xt_LOG,xt_tcpudp,xt_addrtype,xt_CHECKSUM,xt_nat,xt_comment,xt_set,ipt_REJECT,xt_CT,xt_pkttype,ip_tables,iptable_nat,xt_MASQUERADE,iptable_mangle,xt_mark
nf_nat                 65536  4 xt_nat,nft_chain_nat,iptable_nat,xt_MASQUERADE

