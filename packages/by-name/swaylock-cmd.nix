{
  lib,
  writeShellApplication,
  fetchurl,
  swaylock-plugin,
  mpvpaper,
}:

let
  nixcon-idle-loop-vid = fetchurl {
    url = "https://github.com/nixcon/2024-intro-generators/raw/refs/heads/main/blender/idle-loop.webm";
    hash = "sha256-xPp7rSRCIumG/FpZ2axTRL4g/6dfWVXXUEJvysBVurw=";
  };
in

writeShellApplication {
  name = "swaylock-cmd";
  text = ''
    ${lib.getExe swaylock-plugin} -f --command "${mpvpaper}/bin/mpvpaper -o 'loop' '*' '${nixcon-idle-loop-vid}'"
  '';
}
