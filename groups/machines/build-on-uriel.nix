{ config, pkgs, ... }:

{
  nix.buildMachines = [
    {
      hostName = "uriel";

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Nix custom ssh-variant that avoids lots of "trusted-users" settings pain
      protocol = "ssh-ng";

      # default is 1 but may keep the builder idle in between builds
      maxJobs = 3;

      # how fast is the builder compared to your local machine
      speedFactor = 10;

      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;
}
