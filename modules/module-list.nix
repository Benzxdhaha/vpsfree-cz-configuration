let
  shared = [
    ./programs/havesnippet.nix
    ./system/monitoring.nix
  ];

  nixos = [
    ./services/monitoring/prometheus/rules.nix
    ./services/sachet.nix
    ./system/logging/nixos.nix
  ];

  vpsadminos = [
    ./system/logging/vpsadminos.nix
  ];
in {
  nixos = shared ++ nixos;
  vpsadminos = shared ++ vpsadminos;
}
