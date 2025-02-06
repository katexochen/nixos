let
  dellp27L = "Dell Inc. DELL P2720D CBHJK53";
  dellp27R = "Dell Inc. DELL P2720D GN2ZS03";
  dellu27 = "Dell Inc. DELL U2717D J0XYN8AOA5ML";
  p14s = "Lenovo Group Limited 0x403A Unknown";
  l14 = "Lenovo Group Limited L15 U133MM45";
in
{
  services.kanshi = {
    enable = true;
    profiles = {
      office.outputs = [
        {
          criteria = p14s;
          status = "enable";
          position = "0,240";
        }
        {
          criteria = dellp27L;
          status = "enable";
          position = "1920,0";
        }
        {
          criteria = dellp27R;
          status = "enable";
          position = "4480,0";
        }
      ];
      home.outputs = [
        {
          criteria = dellu27;
          status = "enable";
          position = "0,0";
        }
        {
          criteria = p14s;
          status = "enable";
          position = "2560,240";
        }
      ];
      undoced.outputs = [
        {
          criteria = p14s;
          status = "enable";
          position = "0,0";
        }
      ];
      mobile-external.outputs = [
        {
          criteria = l14;
          status = "enable";
          position = "0,0";
        }
        {
          criteria = p14s;
          status = "enable";
          position = "1920,0";
        }
      ];
    };
  };
}
