{ pkgs, VARS, ... }:

{
  home.packages = with pkgs; [
    bat
    tldr
    zoxide
  ];

  home.file.".config/oh-my-posh/theme.omp.json" = {
    text = ''
      {
        "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
        "blocks": [
          {
            "alignment": "right",
            "segments": [
              {
                "background": "#29315A",
                "foreground": "#E64747",
                "leading_diamond": "\ue0b6",
                "style": "diamond",
                "template": "{{ .UserName }}",
                "trailing_diamond": "\ue0b4 ",
                "type": "session"
              },
              {
                "background": "#29315A",
                "foreground": "#3EC669",
                "leading_diamond": "\ue0b6",
                "properties": {
                  "style": "folder"
                },
                "style": "diamond",
                "template": "\ue5ff {{ .Path }}",
                "trailing_diamond": "\ue0b4",
                "type": "path"
              },
              {
                "background": "#29315A",
                "foreground": "#43CCEA",
                "leading_diamond": " \ue0b6",
                "properties": {
                  "branch_icon": "\ue725 ",
                  "cherry_pick_icon": "\ue29b ",
                  "commit_icon": "\uf417 ",
                  "fetch_status": false,
                  "fetch_upstream_icon": false,
                  "merge_icon": "\ue727 ",
                  "no_commits_icon": "\uf0c3 ",
                  "rebase_icon": "\ue728 ",
                  "revert_icon": "\uf0e2 ",
                  "tag_icon": "\uf412 "
                },
                "style": "diamond",
                "template": "{{ .HEAD }}",
                "trailing_diamond": "\ue0b4",
                "type": "git"
              },
              {
                "type": "kubectl",
                "style": "diamond",
                "leading_diamond": " \ue0b6",
                "trailing_diamond": "\ue0b4",
                "foreground": "#ebcc34",
                "background": "#29315A",
                "template": " 󱃾 {{.Context}}{{if .Namespace}} :: {{.Namespace}}{{end}} ",
                "properties": {
                  "context_aliases": {
                    
                  }
                }
              },

              {
                "type": "project",
                "style": "diamond",
                "leading_diamond": " \ue0b6",
                "trailing_diamond": "\ue0b4",
                "background": "#29315A",
                "foreground": "#ffeb3b",
                "template": " {{ if .Error }}{{ .Error }}{{ else }}{{ if .Version }} {{.Version}}{{ end }} {{ if .Name }}{{ .Name }}{{ end }}{{ end }} "
              },
              {
                "background": "#29315A",
                "foreground": "#E4F34A",
                "leading_diamond": " \ue0b6",
                "properties": {
                  "fetch_version": false
                },
                "style": "diamond",
                "template": "\ue235{{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Full }}{{ end }}",
                "trailing_diamond": "\ue0b4",
                "type": "python"
              },
              {
                "background": "#29315A",
                "foreground": "#7FD5EA",
                "leading_diamond": " \ue0b6",
                "properties": {
                  "fetch_version": false
                },
                "style": "diamond",
                "template": "\ue626{{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}",
                "trailing_diamond": "\ue0b4",
                "type": "go"
              },
              {
                "background": "#29315A",
                "foreground": "#42E66C",
                "leading_diamond": " \ue0b6",
                "properties": {
                  "fetch_version": false
                },
                "style": "diamond",
                "template": "\ue718{{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }}",
                "trailing_diamond": "\ue0b4",
                "type": "node"
              },
              {
                "background": "#29315A",
                "foreground": "#E64747",
                "leading_diamond": " \ue0b6",
                "properties": {
                  "fetch_version": false
                },
                "style": "diamond",
                "template": "\ue791{{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}",
                "trailing_diamond": "\ue0b4",
                "type": "ruby"
              },
              {
                "background": "#29315A",
                "foreground": "#E64747",
                "leading_diamond": " \ue0b6",
                "properties": {
                  "fetch_version": false
                },
                "style": "diamond",
                "template": "\ue738{{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}",
                "trailing_diamond": "\ue0b4",
                "type": "java"
              },
              {
                "background": "#29315A",
                "foreground": "#9B6BDF",
                "leading_diamond": " \ue0b6",
                "properties": {
                  "fetch_version": false
                },
                "style": "diamond",
                "template": "\ue624{{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ",
                "trailing_diamond": "\ue0b4",
                "type": "julia"
              },
              {
                "background": "#29315A",
                "foreground": "#9B6BDF",
                "foreground_templates": [
                  "{{if eq \"Charging\" .State.String}}#40c4ff{{end}}",
                  "{{if eq \"Discharging\" .State.String}}#ff5722{{end}}",
                  "{{if eq \"Full\" .State.String}}#4caf50{{end}}"
                ],
                "leading_diamond": " \ue0b6",
                "properties": {
                  "charged_icon": " ",
                  "charging_icon": "\u21e1 ",
                  "discharging_icon": "\u21e3 "
                },
                "style": "diamond",
                "template": "{{ if not .Error }}{{ .Icon }}{{ .Percentage }}{{ end }}{{ .Error }}",
                "trailing_diamond": "\ue0b4",
                "type": "battery"
              }
            ],
            "type": "prompt"
          },
          {
            "alignment": "left",
            "newline": true,
            "segments": [
              {
                "background": "#29315A",
                "foreground": "#AEA4BF",
                "leading_diamond": "\ue0b6",
                "properties": {
                  "style": "austin",
                  "threshold": 150
                },
                "style": "diamond",
                "template": "{{ .FormattedMs }}",
                "trailing_diamond": "\ue0b4 ",
                "type": "executiontime"
              },
              {
                "background": "#29315A",
                "foreground": "#7FD5EA",
                "style": "diamond",
                "template": "{{.Icon}} ",
                "type": "os"
              }, 
              {
                "background": "#29315A",
                "foreground": "#7FD5EA",
                "leading_diamond": "\ue0b6",
                "style": "diamond",
                "template": "\u276f",
                "trailing_diamond": "\ue0b4",
                "type": "text"
              }
            ],
            "type": "prompt"
          }
        ],
        "final_space": true,
        "version": 3
      }
    '';
  };

  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      theme = "gnzh"; #"af-magic";
      plugins = [
        "sudo"
        "terraform"
        "systemadmin"
        # "vi-mode"
        "git"
        "fzf"
        # "autoenv"
        "direnv"
        "fluxcd"
      ];
    };

    shellAliases = {
      ll = "ls -l";
      nix-rebuild = "$NIXOS_CONFIG_DIR/scripts/rebuild";
      nix-run = "nix-shell --run $SHELL -p";
      network-restart = "nmcli networking off && sleep 2 && nmcli networking on";
    };

    initContent = ''
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.omp.json)"
      eval "$(fzf --zsh)"
      export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
      export FZF_COMPLETION_TRIGGER='**'
      export FZF_DEFAULT_OPTS="
        --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
        --prompt='∼ ' --pointer='▶' --marker='✓'
      "   

    '';

    history = {
      size = 10000;
    };
  };
}
