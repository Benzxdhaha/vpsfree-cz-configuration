{ config, pkgs, ... }:
{
  imports = [  ./hydra-common.nix ];

  nix.gc = {
    automatic = true;
    dates = "05:15";
    options = ''--max-freed "$((32 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = pkgs.lib.singleton ''
    command="nice -n20 nix-store --serve --write" ${pkgs.lib.readFile ./static/id_buildfarm.pub}
  '';

  #users.extraUsers.hydra.uid = config.ids.uids.hydra;
  users.extraUsers.hydra.group = "hydra";
  users.extraUsers.hydra.openssh.authorizedKeys.keys = pkgs.lib.singleton ''
    command="nice -n20 nix-store --serve --write" ${pkgs.lib.readFile ./static/id_buildfarm.pub}
  '';

}
