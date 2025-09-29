{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Configuration de base pour agenix
  age = {
    # Identité pour déchiffrer les secrets (clé SSH)
    identityPaths = [ "/home/xophe/.ssh/id_ed25519" ];

    # Secrets définition (exemple)
    secrets = {
      # Exemple: atuin-key pour l'historique shell synchronisé
      # atuin-key = {
      #   file = ../../secrets/atuin-key.age;
      #   owner = "xophe";
      #   group = "users";
      #   mode = "0400";
      # };
    };
  };
}
