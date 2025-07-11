{
  mkSwayWebapp,
}:

mkSwayWebapp {
  name = "teams";
  url = "https://teams.microsoft.com/";
  desktopItemArgs = {
    desktopName = "Microsoft Teams";
    genericName = "Business Communication";
  };
}
