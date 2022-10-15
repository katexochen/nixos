{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles = {
      katexochen = {
        id = 0;
        isDefault = true;
        settings = {
          "browser.aboutwelcome.enabled" = false;
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "browser.newtabpage.enabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "https://search.nixos.org/packages";
          "browser.startup.page" = 3;
          "browser.tabs.unloadOnLowMemory" = true;
          "browser.warnOnQuit" = false;

          # Privacy
          # https://github.com/arcnmx/home/blob/58a00746ecbcfb3eba4b157a7a22641486943c84/cfg/firefox/default.nix
          "app.shield.optoutstudies.enabled" = true;
          "beacon.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
          "browser.onboarding.enabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.updateURL" = "";
          "browser.search.update" = false;
          "browser.selfsupport.url" = "";
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "device.sensors.enabled" = false;
          "devtools.onboarding.telemetry.logged" = false;
          "devtools.webide.autoinstallADBHelper" = false;
          "devtools.webide.autoinstallFxdtAdapters" = false;
          "devtools.webide.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.enable_performance" = false;
          "dom.ipc.plugins.reportCrashURL" = false;
          "experiments.enabled" = false;
          "extensions.getAddons.cache.enabled" = false;
          "extensions.pocket.enabled" = true;
          "geo.enabled" = false;
          "geo.wifi.uri" = false;
          "network.allow-experiments" = false;
          "network.captive-portal-service.enabled" = false;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.introCount" = 20;
          "security.family_safety.mode" = 0;
          "services.sync.prefs.sync.browser.safebrowsing.malware.enabled" = false;
          "services.sync.prefs.sync.browser.safebrowsing.phishing.enabled" = false;
          "services.sync.prefs.sync.privacy.donottrackheader.value" = false;
          "social.directories" = "";
          "social.remote-install.enabled" = false;
          "social.toast-notifications.enabled" = false;
          "social.whitelist" = "";
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;

          # concessions
          "network.dns.disablePrefetch" = false;
          "network.http.speculative-parallel-limit" = 8;
          "network.predictor.cleaned-up" = true;
          "network.predictor.enabled" = true;
          "network.prefetch-next" = true;
          "security.dialog_enable_delay" = 300;
        };
      };
    };
  };
}
