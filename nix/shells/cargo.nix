{ pkgs ? import <nixpkgs> { } }:

# This file contains a development shell for running and working on Cargo.
pkgs.mkShell rec {
  name = "rustc-perf";
  buildInputs = with pkgs; [
    git
    curl
    gnumake
    pkg-config
    openssl

    rustup

    # Required for nested shells in lorri to work correctly.
    bashInteractive
  ];

  # Always show backtraces.
  RUST_BACKTRACE = 1;
}
