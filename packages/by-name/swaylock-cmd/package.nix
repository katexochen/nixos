{
  lib,
  writeShellApplication,
  fetchWithOras,
  swaylock-plugin,
  mpvpaper,
}:

let
  # nixcon-idle-loop-vid = fetchurl {
  #   url = "https://github.com/nixcon/2024-intro-generators/raw/refs/heads/main/blender/idle-loop.webm";
  #   hash = "sha256-xPp7rSRCIumG/FpZ2axTRL4g/6dfWVXXUEJvysBVurw=";
  # };
  spain-vid = fetchWithOras {
    name = "spain-vid";
    image = "ghcr.io/katexochen/ca-store";
    sha256 = "c09449047285c4e421912abeaee8fa55947620c8acbfe19f7993206a0918a91f";
  };
in

writeShellApplication {
  name = "swaylock-cmd";
  text = ''
    ${lib.getExe swaylock-plugin} -f --command "${mpvpaper}/bin/mpvpaper --auto-pause -o 'loop --deinterlace=yes --no-audio' '*' '${spain-vid}'"
  '';
}
