nix flake update
sudo nixos-rebuild switch --flake $NIXOS_CONFIG_DIR#nixos --upgrade
