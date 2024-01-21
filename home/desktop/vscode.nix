{ pkgs, ... }: {
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions;
      [
        eamodio.gitlens
        github.vscode-github-actions
        github.copilot-chat
        github.copilot
        golang.go
        hashicorp.terraform
        james-yu.latex-workshop
        jnoortheen.nix-ide
        mkhl.direnv
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode-remote.remote-ssh
        ms-vscode.cpptools
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        skellock.just
        streetsidesoftware.code-spell-checker
        timonwong.shellcheck
        tsandall.opa
        yzhang.markdown-all-in-one
        zxh404.vscode-proto3
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "theme-bluloco-light";
          publisher = "uloco";
          version = "3.7.3";
          sha256 = "1il557x7c51ic9bjq7z431105m582kig9v2vpy3k2z3xhrbb0211";
        }
        {
          name = "vscode-emacs-minimum";
          publisher = "jamesyang999";
          version = "1.1.1";
          sha256 = "sha256-qxnAhT2UGTQmPw9XmdBdx0F0NNLAaU1/ES9jiqiRrGI=";
        }
        {
          name = "increment-selection";
          publisher = "albymor";
          version = "0.2.0";
          sha256 = "sha256-iP4c0xLPiTsgD8Q8Kq9jP54HpdnBveKRY31Ro97ROJ8=";
        }
        {
          name = "quicktype";
          publisher = "quicktype";
          version = "12.0.46";
          sha256 = "sha256-NTZ0BujnA+COg5txOLXSZSp8TPD1kZNfZPjnvZUL9lc=";
        }
        {
          name = "vscode-bazel";
          publisher = "bazelbuild";
          version = "0.7.0";
          sha256 = "05wvih09184bsp4rv2m55z0sasra2qrvch5m3bkbrjq7rcqgibgx";
        }
        {
          name = "vscode-ansi";
          publisher = "iliazeus";
          version = "1.1.6";
          sha256 = "sha256-ZPV8zd/GkXOGf6s8fz9ZPmC3i1jO0wFAqV0E67lW0do=";
        }
        {
          name = "helm-intellisense";
          publisher = "Tim-Koehler";
          version = "0.14.3";
          sha256 = "sha256-TcXn8n6mKEFpnP8dyv+nXBjsyfUfJNgdL9iSZwA5eo0=";
        }
        {
          name = "vscode-testscript";
          publisher = "twpayne";
          version = "0.0.4";
          sha256 = "sha256-KOmcJlmmdUkC+q0AQ/Q/CQAeRgQPr6nVO0uccUxHmsY=";
        }
      ];
    userSettings = {
      "C_Cpp.clang_format_fallbackStyle" = "{ BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4 }";
      "C_Cpp.clang_format_style" = "{ BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4 }";
      "cSpell.allowCompoundWords" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.bracketPairColorization.enabled" = false;
      "editor.fontFamily" = "'Droid Sans Mono', 'monospace', monospace, 'Font Awesome 6 Free', 'Font Awesome 6 Brands', 'FiraCode Nerd Font'";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.multiCursorModifier" = "ctrlCmd";
      "editor.suggest.preview" = true;
      "editor.suggest.shareSuggestSelections" = true;
      "editor.suggestSelection" = "recentlyUsedByPrefix";
      "enableTelemetry" = false;
      "explorer.confirmDragAndDrop" = false;
      "extensions.ignoreRecommendations" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "git.autofetch" = true;
      "git.enableSmartCommit" = true;
      "git.mergeEditor" = true;
      "gitlens.codeLens.enabled" = false;
      "gitlens.statusBar.enabled" = false;
      "go.buildTags" = "integration";
      "go.coverageOptions" = "showUncoveredCodeOnly";
      "go.coverOnSingleTest" = true;
      "go.coverOnSingleTestFile" = true;
      "go.lintFlags" = [ "--fast" ];
      "go.lintTool" = "golangci-lint";
      "go.testFlags" = [ "-count=1" "-race" "-v" ];
      "go.testTimeout" = "2m";
      "gopls" = { "formatting.gofumpt" = true; };
      "java.saveActions.organizeImports" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "latex-workshop.bibtex-fields.sort.enabled" = true;
      "latex-workshop.bibtex-format.sort.enabled" = true;
      "latex-workshop.bibtex-format.trailingComma" = true;
      "latex-workshop.latex.recipe.default" = "lastUsed";
      "latex-workshop.linting.chktex.enabled" = true;
      "latex-workshop.linting.lacheck.enabled" = true;
      "latex-workshop.message.update.show" = false;
      "latex-workshop.view.pdf.viewer" = "tab";
      "liveServer.settings.donotShowInfoMsg" = true;
      "liveshare.audio.joinCallBehavior" = "accept";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          };
        };
      };
      "open-in-browser.default" = "firefox";
      "outline.showFields" = false;
      "python.languageServer" = "Pylance";
      "redhat.telemetry.enabled" = false;
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.scrollback" = 10000;
      "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Bluloco Light";
      "yaml.completion" = true;
      "yaml.hover" = true;

      "[latex]" = {
        "editor.wordWrap" = "on";
      };

      "[markdown]" = {
        "editor.quickSuggestions" = {
          "other" = true;
          "comments" = true;
          "strings" = true;
        };
      };

      "github.copilot.enable" = {
        "*" = true;
        "yaml" = true;
        "plaintext" = false;
        "markdown" = false;
      };
    };
    keybindings = [
      {
        key = "ctrl+0";
        command = "workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
      }
      {
        key = "ctrl+0";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }
      {
        key = "numpad_add";
        command = "workbench.action.navigateBack";
      }
      {
        key = "numpad_subtract";
        command = "workbench.action.navigateForward";
      }
      {
        key = "ctrl+q";
        command = "workbench.action.closeWindow";
      }
      {
        key = "ctrl+shift+q";
        command = "workbench.action.quit";
      }
    ];
  };
}
