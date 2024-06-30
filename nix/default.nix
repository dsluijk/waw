{
  pkgs,
  lib,
  stdenv,
  version,
  system,
  inputs,
  ...
}:
stdenv.mkDerivation {
  inherit version system;
  name = "waw";
  src = lib.cleanSource ../src;
  buildInputs = [
    pkgs.bun
    pkgs.sassc
    pkgs.gtksourceview
    pkgs.webkitgtk
    pkgs.accountsservice
  ];

  buildPhase = ''
    mkdir -p $out/bin
    sassc style.scss $out/style.css --style compressed
    bun build ./index.ts --minify --outdir $out --external resource://* --external gi://*

    cat << EOF >> $out/bin/waw
    #!${pkgs.bash}/bin/bash
    ${inputs.ags.packages.${system}.default}/bin/ags -c $out/index.js -b wawdev
    EOF
    chmod +x $out/bin/waw
  '';
}
