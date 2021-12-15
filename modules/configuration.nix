{ pkgs, ... }:
let blog = pkgs.writeTextDir "/index.html" "hi there";
in {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ./host.nix
  ];

  boot.cleanTmpDir = true;
  networking.hostName = "bellona";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrmYV5SN6zwFKC/eSg4ochOrb0F6XkzHYT+2lzv5ej8 chris.pickard@tangramflex.com"
  ];
  services.nginx = {
    enable = true;
    virtualHosts."pickard.cc" = {
      forceSSL = true;
      enableACME = true;
      root = "${blog}";
    };
  };
  security.acme = {
    acceptTerms = true;
    certs = { "pickard.cc".email = "chrispickard9@gmail.com"; };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
