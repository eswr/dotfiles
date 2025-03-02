{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
  }: let
    makeHomeManagerConfiguration = {
      system,
      username,
      homeDirectory ? "/home/${username}",
    }: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./modules/home.nix
          {
            home = {
              inherit homeDirectory username;
              stateVersion = "23.11";
            };
          }
        ];
      };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    homeConfigurations.eswr = makeHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "eswr";
    };
    homeConfigurations.eswr-ci = makeHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "runner";
      homeDirectory = "/home/runner";
    };
    darwinConfigurations.eswr-laptop = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ./modules/macos.nix
      ];
    };
  };
}
