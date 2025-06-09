{ writeShellApplication }:

writeShellApplication {
  name = "impermanence-persist";
  text = builtins.readFile ./persist.sh;
}
