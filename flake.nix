{
  description = "Deployment for my server cluster";

  # For accessing `deploy-rs`'s utility Nix functions
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";
    oxidized-endlessh = {
      url = "github:chrispickard/oxidized-endlessh";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
  };

  outputs = inputs@{ self, nixpkgs, deploy-rs, oxidized-endlessh, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ oxidized-endlessh.overlay ];
      };
    in {
      nixosConfigurations.bellona = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          oxidized-endlessh.nixosModules.oxidized-endlessh
          ./modules/hardware-configuration.nix
          ./modules/networking.nix
          ./modules/configuration.nix
        ];
      };

      deploy.nodes.bellona = {
        hostname = "pickard.cc";
        sshUser = "root";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.bellona;
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
