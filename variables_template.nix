{
  hostSettings = rec {
    hostname = "nixos";
    configDir = "$HOME/.nix/";
    system = "x86_64-linux";
  };

  userSettings = rec {
    username = "username";
    name = "Name Lastname";
    email = "email@example.com";
  };
}
