let
  dellp27L = "Dell Inc. DELL P2720D CBHJK53";
  dellp27R = "Dell Inc. DELL P2720D GN2ZS03";
  dellu27 = "Dell Inc. DELL U2717D J0XYN8AOA5ML";
  nt14 = "LG Display 0x06ED Unknown";
in
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "office";
        profile.outputs = [
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
      }
      {
        profile.name = "home";
        profile.outputs = [
          {
            criteria = dellu27;
            status = "enable";
            position = "0,0";
          }
          {
            criteria = nt14;
            status = "enable";
            position = "2560,240";
          }
        ];
      }
    ];
  };
}
