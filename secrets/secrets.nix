let
  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9unP5uSVqN8erJ8wsFDuG//bWRAwdJkyNZ2EBGZiGw root@bellona"
];
in
{
  "grafana-agent.age".publicKeys = systems;
  "grafana-api-key.age".publicKeys = systems;
}
