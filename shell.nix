{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.hugo
    pkgs.entr
    pkgs.mkcert
    pkgs.caddy
    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
