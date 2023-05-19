let
  dellp27L = "Dell Inc. DELL P2720D CBHJK53";
  dellp27R = "Dell Inc. DELL P2720D GN2ZS03";
in {
  services.kanshi = {
    enable = true;
    profiles = {
      office_nt5.outputs = [
        {
          criteria = dellp27L;
          status = "enable";
          position = "0,0";
        }
        {
          criteria = dellp27R;
          status = "enable";
          position = "2560,0";
        }
      ];
    };
  };
}
