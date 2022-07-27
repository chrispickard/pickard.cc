{
  description = "Deployment for my server cluster";

  # For accessing `deploy-rs`'s utility Nix functions
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-cli = { url = "github:cole-h/agenix-cli"; };
    oxidized-endlessh = {
      url = "github:chrispickard/oxidized-endlessh";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
  };

  outputs = inputs@{ self, nixpkgs, deploy-rs, agenix, oxidized-endlessh, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          oxidized-endlessh.overlay
          (final: prev: {
            agenix = inputs.agenix-cli.defaultPackage.${system};
          })
        ];
      };
    in {
      nixosConfigurations.bellona = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          oxidized-endlessh.nixosModules.oxidized-endlessh
          agenix.nixosModules.age
          ./modules/hardware-configuration.nix
          ./modules/networking.nix
          ./modules/configuration.nix
        ];
      };

      deploy.nodes.bellona = {
        hostname = "pickard.cc";
        sshUser = "root";
        # magicRollback = false;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.bellona;
        };
      };

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs =
          [ deploy-rs.packages.x86_64-linux.deploy-rs pkgs.hugo pkgs.just ];
      };
      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
