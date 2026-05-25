{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.my.role == "client") {
    environment.systemPackages = [
      (pkgs.chromium.override { enableWideVine = true; })
    ];

    programs.chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        "logpjaacgmcbpdkdchjiaagddngobkck" # shortkeys
      ];
      extraOpts = {
        # Defer to Bitwarden
        PasswordManagerEnabled = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;

        # Privacy
        MetricsReportingEnabled = false;
        SearchSuggestEnabled = false;
        UrlKeyedAnonymizedDataCollectionEnabled = false;

        # Startup & UI
        RestoreOnStartup = 1; # continue where you left off
        ShowHomeButton = false;
        BookmarkBarEnabled = false;
        SpellcheckEnabled = true;
        SpellcheckLanguage = [
          "en-US"
          "de"
        ];

        # UX
        BackgroundModeEnabled = false;
        DefaultBrowserSettingEnabled = false;
      };
    };
  };
}
