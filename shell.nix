{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.hugo
    pkgs.entr
    pkgs.mkcert
    pkgs.caddy
    pkgs.python38Packages.pygments
    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
