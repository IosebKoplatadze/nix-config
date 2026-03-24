{
  description = "Declarative macOS setup (nix-darwin + Home Manager + Homebrew)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
    let
      username = "ioseb.koplatadze";
    in
    {
      darwinConfigurations."ioseb-mac" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self inputs username;
        };
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hmbackup";
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
}
