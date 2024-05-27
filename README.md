# NixOS Config
My NixOS config, thanks to [aurecchia's config](https://github.com/aurecchia/nixos)

# Fresh install

Pre-requisite:

- Git-crypt key ready*

(*) The encrypted file do not hold anything ultra sensitive. It's mostly to not leak some infos (emails I don't want publicly available, home network topology, etc.).
They can also be rewritten (see `variables_template.nix`).


Ensure that the infos in `variables.nix` are correct.

```bash
# Clone Repository
nix-shell -p git git-crypt
git clone https://github.com/TimP4w/nix
mv nix .nix

# Decrypt Secrets
cd .nix
git-crypt unlock <path to nixos_gitcrypt.key>

# Rebuild system
sudo nixos-rebuild switch --flake .#nixos
sudo reboot
```


# Rebuild
```bash
cd $NIXOS_CONFIG_DIR  
sudo nixos-rebuild switch --flake .#nixos

--- OR ---

nix-rebuild
```

# Clean old stores
```bash
cd $NIXOS_CONFIG_DIR  
sudo scripts/cleanup.sh

--- OR ---

nix-cleanup
```

# TODO
- [ ] Add Kitty
- [ ] Add Hyprland
- [ ] Configure default apps (see brave)
- [ ] Add gpg
