{ VARS, pkgs, ... }:

{
  home.packages = [ pkgs.git-crypt ]; # https://github.com/AGWA/git-crypt

  programs.git = {
    enable = true;

    delta = {
      enable = true;
      options = {
        features = "line-numbers decorations";
      };
    };

    extraConfig = {
      commit = {
        verbose = true;
      };

      rebase = {
        abbreviatedCommands = true;
        autosquash = true;
        autostash = true;
        missingCommitsCheck = "warn";
      };

      alias = {
        amend = "commit -a --amend --no-edit";
        cb = "checkout -b";
        ci = "commit";
        co = "checkout";
        fix = "commit --fixup HEAD";
        lg = "!git --no-pager log --graph --oneline --date=human -n 20";
        lga = "!git lg --exclude '*/renovate/*' --all";
        main = "checkout origin/main";
        pf = "push --force-with-lease origin HEAD";
        pu = "push -u origin";
        re = "rebase -i origin/main --update-refs";
        ru = "remote update --prune";
        s = "status --short --branch --ahead-behind";
        sw = "sw";
        wip = "commit -am \"wip\"";
        gone = "!f() { git fetch --all --prune; git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f";

        lgnice = "
          log --graph --abbrev-commit --decorate -n 30 \
          --format=format:'%C(bold blue)%h%C(reset)%C(auto)%d%C(reset)
          %C(auto)%s%C(reset) %C(dim green)(%ae)%C(reset)'";
      };

      push = {
        default = "matching";
      };

      pull = {
        ff = "only";
      };

      init = {
        defaultBranch = "main";
      };

      merge = {
        tool = "vscode";
        conflictstyle = "zdiff3";
      };

      mergetool = {
        layout = "(LOCAL,MERGED,REMOTE)";
        vscode.cmd = "code --wait $MERGED";
      };

      core = {
        editor = "code --wait";
      };

      difftool = {
        vscode.cmd = "code - -wait - -diff $LOCAL $REMOTE";
      };

      pager.branch = false;
      mergetool.keepBackup = false;
    };
  };

}
