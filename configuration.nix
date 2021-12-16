{ pkgs, ... }:

let
  blog = pkgs.callPackage ./derivation.nix {
    lib = pkgs.lib;
    hugo = pkgs.hugo;
  };
in {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  environment.systemPackages = with pkgs; [ vim ];
  boot.cleanTmpDir = true;
  networking.hostName = "bellona";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrmYV5SN6zwFKC/eSg4ochOrb0F6XkzHYT+2lzv5ej8 chris.pickard@tangramflex.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6yCtIHyPSpb+bF+eluLXfXEBRlpXWIgEhfteQcEamU chrispickard9@gmail.com"
  ];
  services.nginx = {
    enable = true;
    virtualHosts."pickard.cc" = {
      forceSSL = true;
      enableACME = true;
      root = "${blog}/";
    };
  };
  services.tailscale.enable = true;
  security.acme = {
    acceptTerms = true;
    certs = { "pickard.cc".email = "chrispickard9@gmail.com"; };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
