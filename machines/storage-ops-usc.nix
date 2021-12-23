{ ... }:

{
  imports = [ ../groups/rootless.nix ../groups/ansible.nix ];

  programs = {
    zsh.initExtra = ''
      ansible-short-diff () {
        export ANSIBLE_DISPLAY_OK_HOSTS=no ANSIBLE_DISPLAY_SKIPPED_HOSTS=no ANSIBLE_NOCOLOR=false 
      }
    '';
  };
}
