sudo nix-collect-garbage -d
sudo nix-store --gc
sudo nix store verify --all
sudo nix store repair --all
