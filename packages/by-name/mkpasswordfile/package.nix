{ writeShellApplication }:
writeShellApplication {
  name = "mkpasswordfile";
  text = ''mkpasswd -m sha-512 | sudo tee "$1" > /dev/null'';
}
