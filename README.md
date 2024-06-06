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
mv nixos .nix

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

# CheatSheet

### Home manager fails 
```
sudo journalctl -u home-manager-timp4w -r
```

# TODO
- [ ] Add Hyprland
- [ ] Configure default apps (see brave)
- [ ] Add gpg

# Links
- [NixOS packages](https://search.nixos.org/packages) - Packages DB
- [Flake Parts](https://github.com/hercules-ci/flake-parts) - Framework to write nix flakes
- [flake-utils
](https://github.com/numtide/flake-utils) - Pure Nix flake utility functions.
- [nix-update](https://github.com/Mic92/nix-update) - Nix-update updates versions/source hashes of nix packages.
- [musnix](https://github.com/musnix/musnix) - Real-time audio in NixOS
- [Nix Community Templates](https://github.com/nix-community/templates) - A collection of basic [development] templates. Using flake-utils.
- [nix-darwin](https://github.com/LnL7/nix-darwin) - Nix modules for darwin, `/etc/nixos/configuration.nix` for macOS.
- [NUR](https://github.com/nix-community/NUR/) - The Nix User Repository (NUR) is a community-driven meta repository for Nix packages.
