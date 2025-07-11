{
  mkSwayWebapp,
  pkgs,
}:

(mkSwayWebapp {
  name = "discord";
  url = "https://discord.com/login";
  fromPkg = pkgs.discord;
}).overrideAttrs
  {
    postBuild = ''
      substituteInPlace $out/share/applications/discord.desktop \
        --replace-fail Exec=Discord Exec=discord
    '';
  }
