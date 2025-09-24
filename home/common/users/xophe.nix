# Configuration spécifique à l'utilisateur xophe
{ config, lib, pkgs, ... }:
{
  # Configuration utilisateur personnalisée
  home.packages = with pkgs; [
    # Outils personnels xophe
    # Ajoutez ici des packages spécifiques à xophe
  ];

  # Configuration git personnalisée - configuration principale dans shell/git.nix
  programs.git.extraConfig = {
    # Personnalisations spécifiques à xophe
    #commit.gpgsign = true;
  };

  # Configuration shell personnalisée
  programs.zsh.shellAliases = {
    # Alias personnalisés pour xophe
    #work = "cd ~/work";
    #personal = "cd ~/personal";
  };

  # Variables d'environnement personnalisées
  home.sessionVariables = {
    # Variables spécifiques à xophe
    #EDITOR = "nvim";
  };
}
