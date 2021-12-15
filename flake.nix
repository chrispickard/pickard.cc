{
  description = "Deployment for my server cluster";

  # For accessing `deploy-rs`'s utility Nix functions
  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs = { self, nixpkgs, deploy-rs }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.bellona = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
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
