{
  description = "A NixOS flake with aliases in the Steam FHS environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      in
      {
        devShell = pkgs.mkShell rec {

          shellHook = ''
            echo "Entering Steam FHS environment..."

            # Define aliases
            alias myalias='echo "This is my custom alias"'
            alias startsteam='steam-run steam'
            
            # Optionally, run custom code here
            steam-run bash -c '
              echo "Running custom code inside Steam FHS environment..."
              # Your custom code here
            '
          '';
        };
      });
}
