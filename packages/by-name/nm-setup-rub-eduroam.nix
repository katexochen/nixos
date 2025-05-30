{
  writeShellApplication,
  writeTextFile,
  networkmanager,
}:
let
  rub-eduroam-cert = writeTextFile {
    name = "rub-eduroam-cert";
    text = ''
      -----BEGIN CERTIFICATE-----
      MIIDwzCCAqugAwIBAgIBATANBgkqhkiG9w0BAQsFADCBgjELMAkGA1UEBhMCREUx
      KzApBgNVBAoMIlQtU3lzdGVtcyBFbnRlcnByaXNlIFNlcnZpY2VzIEdtYkgxHzAd
      BgNVBAsMFlQtU3lzdGVtcyBUcnVzdCBDZW50ZXIxJTAjBgNVBAMMHFQtVGVsZVNl
      YyBHbG9iYWxSb290IENsYXNzIDIwHhcNMDgxMDAxMTA0MDE0WhcNMzMxMDAxMjM1
      OTU5WjCBgjELMAkGA1UEBhMCREUxKzApBgNVBAoMIlQtU3lzdGVtcyBFbnRlcnBy
      aXNlIFNlcnZpY2VzIEdtYkgxHzAdBgNVBAsMFlQtU3lzdGVtcyBUcnVzdCBDZW50
      ZXIxJTAjBgNVBAMMHFQtVGVsZVNlYyBHbG9iYWxSb290IENsYXNzIDIwggEiMA0G
      CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCqX9obX+hzkeXaXPSi5kfl82hVYAUd
      AqSzm1nzHoqvNK38DcLZSBnuaY/JIPwhqgcZ7bBcrGXHX+0CfHt8LRvWurmAwhiC
      FoT6ZrAIxlQjgeTNuUk/9k9uN0goOA/FvudocP05l03Sx5iRUKrERLMjfTlH6VJi
      1hKTXrcxlkIF+3anHqP1wvzpesVsqXFP6st4vGCvx9702cu+fjOlbpSD8DT6Iavq
      jnKgP6TeMFvvhk1qlVtDRKgQFRzlAVfFmPHmBiiRqiDFt1MmUUOyCxGVWOHAD3bZ
      wI18gfNycJ5v/hqO2V81xrJvNHy+SE/iWjnX2J14np+GPgNeGYtEotXHAgMBAAGj
      QjBAMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBS/
      WSA2AHmgoCJrjNXyYdK4LMuCSjANBgkqhkiG9w0BAQsFAAOCAQEAMQOiYQsfdOhy
      NsZt+U2e+iKo4YFWz827n+qrkRk4r6p8FU3ztqONpfSO9kSpp+ghla0+AGIWiPAC
      uvxhI+YzmzB6azZie60EI4RYZeLbK4rnJVM3YlNfvNoBYimipidx5joifsFvHZVw
      IEoHNN/q/xWA5brXethbdXwFeilHfkCoMRN3zUA7tFFHei4R40cR3p1m0IvVVGb6
      g1XqfMIpiRvpb7PO4gWEyS8+eIVibslfwXhjdFjASBgMmTnrpMwatXlajRWc2BQN
      9noHV8cigwUtPJslJj0Ys6lDfMjIq2SPDqO/nBudMNva0Bkuqjzx+zOAduTNrRlP
      BSeOE6Fuwg==
      -----END CERTIFICATE-----
    '';
  };
in
writeShellApplication {
  name = "nm-setup-rub-eduroam";
  runtimeInputs = [ networkmanager ];
  text = ''
    set -euo pipefail

    user="''${1:-}"
    password="''${2:-}"

    if [[ -z "$user" || -z $password ]]; then
      echo "Setup RUB eduroam with networkmanage"
      echo "Usage: $0 <user> <password>"
      exit 1
    fi

    nmcli con delete eduroam || true
    nmcli con add \
      type wifi \
      con-name "eduroam" \
      ssid "eduroam" -- \
      802-1x.eap "ttls" \
      802-1x.identity "$user" \
      802-1x.password "$password" \
      802-1x.anonymous-identity "eduroam@ruhr-uni-bochum.de" \
      802-1x.ca-cert "${rub-eduroam-cert}" \
      802-1x.altsubject-matches "DNS:radius.ruhr-uni-bochum.de" \
      802-1x.phase2-auth "pap" \
      802-1x.system-ca-certs "no" \
      802-11-wireless-security.key-mgmt "wpa-eap" \
      802-11-wireless-security.proto "rsn" \
      802-11-wireless-security.pairwise "ccmp" \
      802-11-wireless-security.group "ccmp,tkip"
  '';
}
