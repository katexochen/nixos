{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;

  # Hook script for Notification + Stop events.
  # Claude Code pipes JSON to stdin with at least { session_id, cwd, hook_event_name, message? }.
  # We surface dir + short session id in the title so the user can tell which terminal
  # window is asking when several sessions are open at once.
  notifySound = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga";

  notifyHook = pkgs.writeShellApplication {
    name = "claude-notify-hook";
    runtimeInputs = with pkgs; [
      jq
      libnotify
      coreutils
      pipewire
    ];
    text = ''
      input=$(cat)
      event=$(jq -r '.hook_event_name // "Notification"' <<<"$input")
      cwd=$(jq -r   '.cwd // empty'                     <<<"$input")
      msg=$(jq -r   '.message // empty'                 <<<"$input")
      sid=$(jq -r   '.session_id // empty'              <<<"$input" | cut -c1-8)
      dir=$(basename "''${cwd:-unknown}")

      case "$event" in
        Stop) [ -z "$msg" ] && msg="Task done" ;;
        *)    [ -z "$msg" ] && msg="Needs attention" ;;
      esac

      notify-send \
        --app-name=claude \
        --icon=utilities-terminal \
        "Claude · $dir''${sid:+ [$sid]}" \
        "$msg"

      # Best-effort chime; don't fail the hook if pipewire isn't reachable.
      pw-play ${notifySound} 2>/dev/null || true
    '';
  };
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user} =
      { config, ... }:
      {
        programs.claude-code = {
          enable = true;

          settings = {
            theme = "auto";
            effortLevel = "xhigh";
            skipDangerousModePermissionPrompt = true;
            feedbackSurveyRate = 0;
            enabledPlugins = {
              "clangd-lsp@claude-plugins-official" = true;
              "rust-analyzer-lsp@claude-plugins-official" = true;
              "nono@always-further" = true;
            };
            permissions = {
              defaultMode = "acceptEdits";
              allow = [
                "Bash(nono why *)"
                "Bash(nono profile guide)"
                "Bash(nono profile validate *)"
                "Bash(nono profile show *)"
                "Read(/nix/store/**)"
              ];
              deny = [
                "Read(./.env)"
                "Read(./.env.*)"
                "Read(~/.ssh/**)"
                "Read(~/.aws/**)"
                "Read(~/.config/gh/hosts.yml)"
                "Read(~/.netrc)"
              ];
              ask = [
                "Bash(git push:*)"
                "Bash(git reset --hard:*)"
                "Bash(rm -rf:*)"
              ];
            };
            hooks = {
              Notification = [
                {
                  hooks = [
                    {
                      type = "command";
                      command = lib.getExe notifyHook;
                    }
                  ];
                }
              ];
              Stop = [
                {
                  hooks = [
                    {
                      type = "command";
                      command = lib.getExe notifyHook;
                    }
                  ];
                }
              ];
            };
          };
        };

        home.packages = [
          pkgs.nono
          (pkgs.writeShellApplication {
            name = "chlorine";
            runtimeInputs = [
              pkgs.nono
              config.programs.claude-code.finalPackage
            ];
            text = ''
              allows=(--allow ~/.cache/nix)
              add_dirs=()
              for src in "$@"; do
                allows+=(--allow "$src")
                add_dirs+=(--add-dir "$src")
              done

              exec nono run \
                --allow-cwd \
                "''${allows[@]}" \
                --profile claude-code \
                -- \
                claude --dangerously-skip-permissions "''${add_dirs[@]}"
            '';
          })
        ];
      };
  };
}
