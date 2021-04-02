{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.hugo
    pkgs.entr
    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
