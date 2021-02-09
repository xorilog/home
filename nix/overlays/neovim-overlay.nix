self: super: {
  tree-sitter-updated = super.tree-sitter.overrideAttrs(oldAttrs: {

    version = "0.17.3";
    sha256 = "sha256-uQs80r9cPX8Q46irJYv2FfvuppwonSS5HVClFujaP+U=";
    cargoSha256 = "sha256-fonlxLNh9KyEwCj7G5vxa7cM/DlcHNFbQpp0SwVQ3j4=";

    postInstall = ''
      PREFIX=$out make install
    '';

  });

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "master";
    src = builtins.fetchGit {
      url = https://github.com/neovim/neovim.git;
    };
    nativeBuildInputs = with self.pkgs; [ unzip cmake pkgconfig gettext tree-sitter-updated ];
  });
}

