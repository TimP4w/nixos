{ pkgs, VARS, ... }:

{
  home.packages = with pkgs; [
    rclone
  ];

  systemd.user.services.rclone-onedrive-mount = {
    Unit = {
      Description = "Service that connects rclone to OneDrive";
      After = [ "default.target" ];
      Requires = [ "default.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };

    Service =
      let
        onedriveDir = "/home/${VARS.userSettings.username}/OneDrive";
      in
      {
        Type = "simple";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${onedriveDir}";
        ExecStart = "${pkgs.rclone}/bin/rclone --vfs-cache-mode writes mount OneDrive: ${onedriveDir}";
        ExecStop = "/run/current-system/sw/bin/fusermount -u ${onedriveDir}";
        Restart = "on-failure";
        RestartSec = "10s";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      };
  };
}
