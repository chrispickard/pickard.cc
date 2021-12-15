{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "8.8.8.8"
 ];
    defaultGateway = "104.248.0.1";
    defaultGateway6 = "2604:a880:800:10::1";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="104.248.12.45"; prefixLength=20; }
{ address="10.17.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="2604:a880:800:10::7e2:b001"; prefixLength=64; }
{ address="fe80::8cad:bcff:fe0a:8292"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "104.248.0.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "2604:a880:800:10::1"; prefixLength = 128; } ];
      };
      
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="8e:ad:bc:0a:82:92", NAME="eth0"
    ATTR{address}=="ea:47:a5:b0:df:a6", NAME="eth1"
  '';
}
