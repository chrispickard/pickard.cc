{ self, pkgs, config, ... }:

let
  blog = pkgs.callPackage ./site/default.nix {
    lib = pkgs.lib;
    hugo = pkgs.hugo;
  };
in {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  system.stateVersion = "22.11";

  environment.systemPackages = with pkgs; [ vim ];
  boot.cleanTmpDir = true;
  networking.hostName = "bellona";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrmYV5SN6zwFKC/eSg4ochOrb0F6XkzHYT+2lzv5ej8 chris.pickard@tangramflex.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6yCtIHyPSpb+bF+eluLXfXEBRlpXWIgEhfteQcEamU chrispickard9@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIs9eNWhNy/wGPo1dHPgxh5UH6Evzcws9Zip3q7Vncz chrispickard9@gmail.com"
  ];
  services.nginx = {
    enable = true;
    virtualHosts."pickard.cc" = {
      forceSSL = true;
      enableACME = true;
      root = "${blog}/";
    };
    virtualHosts."danielleandchris.rsvp" = {
      forceSSL = true;
      enableACME = true;
      globalRedirect = "danielleandchris052823.minted.us";
    };
  };
  nix = {
    # Automatic Nix GC.
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      min-free = ${toString (500 * 1024 * 1024)}
    '';

    # Automatic store optimization.
    settings.auto-optimise-store = true;

  };

  services.tailscale.enable = true;
  services.oxidized-endlessh = {
    enable = true;
    opts.addrs = [ "[::]:2222" ];
  };
  security.acme = {
    acceptTerms = true;
    certs = { "pickard.cc".email = "chrispickard9@gmail.com"; };
    certs = { "danielleandchris.rsvp".email = "chrispickard9@gmail.com"; };
  };
  networking.firewall = {
    allowedTCPPorts = [ 80 443 2222 ];
    checkReversePath = "loose";
  };
}
