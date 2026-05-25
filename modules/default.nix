{
  imports =
    let
      entries = builtins.readDir ./.;
      names = builtins.attrNames entries;
      isNixFile =
        name: type: type == "regular" && builtins.match ".*\\.nix" name != null && name != "default.nix";
      hasModuleNix = name: type: type == "directory" && builtins.pathExists (./. + "/${name}/module.nix");
      pick =
        name:
        let
          type = entries.${name};
        in
        if isNixFile name type then
          [ (./. + "/${name}") ]
        else if hasModuleNix name type then
          [ (./. + "/${name}/module.nix") ]
        else
          [ ];
    in
    builtins.concatMap pick names;
}
