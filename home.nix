{ config, pkgs, ... }:

{
  home.username = "zaina";
  home.homeDirectory = "/home/zaina";
  home.stateVersion = "26.05"; # Please read the comment before changing.
  
  # Enable gnome keyring
  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "secrets" "ssh" ];

  programs.npm.enable = true;
  programs.fastfetch.enable = true;

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    bash
    zsh
    neovim
    gcc
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
    ripgrep # better grep
    fd # better  find
    lua
    lua-language-server
    clang-tools
    matlab-language-server
    nil
    lazygit
 
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

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionPath = [
    "$HOME/Electrical-Engineering/Y1S2/Professional_Development/MATLAB/Week 6/Fundamentals_1/matlab-nix-imperative/matlab"
  ];

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
      battery="cat /sys/class/power_supply/BAT0/capacity";
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
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # says no to home-manager editing, just want to link
  };

  services.hyprpaper.enable = true;

  # Creates Symlinks for directories or files
  #xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink "/home/zaina/.dotfiles/config/hypr";
  xdg.configFile = {
    "hypr".source = config.lib.file.mkOutOfStoreSymlink "/home/zaina/.dotfiles/config/hypr";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/zaina/.dotfiles/config/nvim";
    "kitty".source = config.lib.file.mkOutOfStoreSymlink "/home/zaina/.dotfiles/config/kitty";
    "fastfetch".source = config.lib.file.mkOutOfStoreSymlink "/home/zaina/.dotfiles/config/fastfetch";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
