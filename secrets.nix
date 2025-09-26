# Agenix secrets configuration
# Ce fichier définit comment chiffrer les secrets avec agenix
# Usage: agenix -e secretname.age
let
  # TODO: Check how this is handled in vdemeester repo.
  # Clés publiques des utilisateurs
  xophe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmfwv6v+lgaQCzA1k8pYf34OxdogFv3wOfeqijYyaZv xophe@nixophe";

  # Clés publiques des machines
  nixophe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXXHBxfD7fzH63//jkvgLXICqdzYr088lC/+ynU9ogD root@nixophe";

  # Groupes d'accès
  users = [ xophe ];
  systems = [ nixophe ];
  all = users ++ systems;
in
{
  # Exemple de secrets (décommentez et adaptez selon vos besoins)
  # "atuin-key.age".publicKeys = [ xophe nixophe ];
  # "wifi-password.age".publicKeys = all;
}
