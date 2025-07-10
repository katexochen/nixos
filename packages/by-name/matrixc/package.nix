{ writeShellApplication, curl }:

writeShellApplication {
  name = "matrixc";
  runtimeInputs = [ curl ];
  text = builtins.readFile ./matrixc.sh;
}
