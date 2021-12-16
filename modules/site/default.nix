{ stdenv, hugo, lib, ... }:

stdenv.mkDerivation rec {
  name = "pickard.cc";
  src = lib.cleanSource ./.;

  nativeBuildInputs = [ hugo ];

  installPhase = ''
    mkdir -p $out
    ${hugo}/bin/hugo -d $out/
  '';

  meta = with lib; {
    description = "chris pickard's weblog";
    homepage = "https://pickard.cc";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
