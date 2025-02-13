{ config, ... }:
let
  allAddresses = {
    primary = { address = "172.16.0.31"; prefix = 32; };
    teng0 = {
      v4 = [
        { address = "172.16.251.38"; prefix = 30; }
      ];
      v6 = [
        { address = "2a03:3b40:42:2:10::2"; prefix = 80; }
      ];
    };
    teng1 = {
      v4 = [
        { address = "172.16.250.38"; prefix = 30; }
      ];
      v6 = [
        { address = "2a03:3b40:42:3:10::2"; prefix = 80; }
      ];
    };
  };
in {
  cluster."cz.vpsfree/nodes/prg/node21" = rec {
    spin = "vpsadminos";

    swpins.channels = [ "prod21_09" ];

    node = {
      id = 122;
      role = "hypervisor";
    };

    host = {
      name = "node21";
      location = "prg";
      domain = "vpsfree.cz";
    };

    netboot = {
      enable = true;
      macs = [
        "44:a8:42:27:c4:d0"
        "44:a8:42:27:c4:d1"
        "44:a8:42:27:c4:d2"
        "44:a8:42:27:c4:d3"
      ];
    };

    addresses = with allAddresses; {
      inherit primary;
      v4 = teng0.v4 ++ teng1.v4;
      v6 = teng0.v6 ++ teng1.v6;
    };

    osNode = {
      networking = {
        interfaces = {
          names = {
            teng0 = "a0:36:9f:61:d1:a0";
            teng1 = "a0:36:9f:61:d1:a2";
          };
          addresses = {
            inherit (allAddresses) teng0 teng1;
          };
        };

        bird = {
          as = 4200001010;
          routerId = "172.16.0.31";
          bgpNeighbours = {
            v4 = [
              { address = "172.16.251.37"; as = 4200001901; }
              { address = "172.16.250.37"; as = 4200001902; }
            ];
            v6 = [
              { address = "2a03:3b40:42:2:10::1"; as = 4200001901; }
              { address = "2a03:3b40:42:3:10::1"; as = 4200001902; }
            ];
          };
        };

        virtIP = addresses.primary;
      };
    };

    services = {
      node-exporter = {};
      osctl-exporter = {};
      vpsadmin-console = {};
    };
  };
}
