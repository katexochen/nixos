{
  mkSwayWebapp,
  pkgs,
}:

mkSwayWebapp {
  name = "spotify";
  url = "https://open.spotify.com/";
  fromPkg = pkgs.spotify;
}
