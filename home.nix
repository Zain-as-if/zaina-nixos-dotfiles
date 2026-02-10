{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zaina";
  home.homeDirectory = "/home/zaina";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.
  
  # Enable gnome keyring
  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "secrets" "ssh" ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    gh
    btop
    fzf
    yazi
    fastfetch
    tmux
    bat
    starship
    hyprpaper
    nix-search-tv
    gcr
    zoxide

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/hypr".source = ./config/hypr;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/zaina/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    size = 16;
    package = pkgs.bibata-cursors;
  };

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true; 

    shellAliases = {
      cd = "z";
      cat = "bat";
      ll = "ls -l";
      la = "ls -al";
      update = "sudo nixos-rebuild switch --flake ~/.dotfiles/#zaina";
      edit = "sudo nvim ~/.dotfiles/";
      nixdelete = "sudo nix-collect-garbage --delete-older-than";
      ns="nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    };

    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      # Other themes to try (gnzh, frisk, frontcube, fox, fino-time, bira, agnoster)
      theme = "jonathan";
      plugins = [
        "git"
	"zoxide"
	"starship"
	"aliases"
	"fzf"
	"sudo"
	"themes"
	"tmux"
	"web-search"
      ];
    };

    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      # temp 
    '';
  };

  #xdg.configFile = {
  #  # uncomment when doing neovim config
  #  # nvim = ./config/nvim;
  #  "hypr/hyprland.conf" = ./config/hypr/hyprland.conf;
  #};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
