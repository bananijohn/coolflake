{
  description = "Not an example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # Installed packages. to search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	  pkgs.neovim
	  pkgs.kitty
	  pkgs.mkalias
	  pkgs.git
	  pkgs.home-manager
	  pkgs.oh-my-zsh
	  pkgs.vesktop
	  pkgs.kitty-img
	  pkgs.kitty-themes
	  pkgs.yabai
	  pkgs.skhd
	  pkgs.fastfetch
	  pkgs.sketchybar
	  pkgs.sketchybar-app-font
	];

	homebrew = {
	  enable = true;
	  # Syntax: "thing"
	  brews = [
	  ];
	  casks = [
	  ];
	  taps = [
	  ];
	  # Deletes unused packages for maximum declaration
	  onActivation.cleanup = "zap";
	  onActivation.autoUpdate = true;
	  onActivation.upgrade = true;
	};

	system.activationScripts.applications.text = let
  env = pkgs.buildEnv {
    name = "system-applications";
    paths = config.environment.systemPackages;
    pathsToLink = "/Applications";
  };
in
  pkgs.lib.mkForce ''
  # Set up applications.
  echo "setting up /Applications..." >&2
  rm -rf /Applications/Nix\ Apps
  mkdir -p /Applications/Nix\ Apps
  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  while read -r src; do
    app_name=$(basename "$src")
    echo "copying $src" >&2
    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  done
      '';

      system.defaults = {
        dock.autohide = true;
	dock.autohide-time-modifier = 0.3;
	dock.autohide-delay = 0.05;
	WindowManager.EnableTopTilingByEdgeDrag = true;
	finder._FXShowPosixPathInTitle = true;
	finder.QuitMenuItem = true;
	finder.ShowStatusBar = true;
      };
      
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToEscape = true;

      # Yabai config ig lmao

      services.yabai = {
        enable = true;
	enableScriptingAddition = true;
	config = {
	  window_placement = "second_child";
	  top_padding = 5;
	  bottom_padding = 5;
	  left_padding = 5;
	  right_padding = 5;
	  window_gap = 5;
	  auto_balance = "off";
	  split_ratio = 5;
	  layout = "bsp";
	  mouse_modifier = "command";
	  mouse_action1 = "move";
	  mouse_action2 = "resize";
	  window_shadow = "float";
	  window_opacity = "on";
	  active_window_opacity = "0.9";
	  normal_window_opacity = "0.7";
        };
      };

      # skhd config lol

      services.skhd = {
        enable = true;
	skhdconfig = "
	cmd - q : open -na /run/current-system/sw/bin/kitty \n
	cmd - f : open -na firefox \n
	cmd - d : open /run/current-system/sw/bin/vesktop \n
	cmd - left : yabai -m window --focus west \n
	cmd - down : yabai -m window --focus south \n
	cmd - up : yabai -m window --focus north \n
	cmd - right : yabai -m window --focus east \n
	cmd - 1 : yabai -m window --focus 1 \n
        cmd - 2 : yabai -m window --focus 2 \n
	cmd - 3 : yabai -m window --focus 3 \n
	cmd - 4 : yabai -m window --focus 4 \n
	cmd - 5 : yabai -m window --focus 5 \n
	cmd - 6 : yabai -m window --focus 6 \n
	cmd - 7 : yabai -m window --focus 7 \n
	cmd - 8 : yabai -m window --focus 8 \n
	cmd - 9 : yabai -m window --focus 9 \n
	cmd - 10 : yabai -m window --focus 10 \n
	cmd + shift - c : yabai -m space --destroy \n
	cmd - c : yabai -m window --close \n
	cmd - m : yabai -m window --minimize \n
	cmd - v : yabai -m window --toggle float \n
	cmd + shift - f : yabai -m window -- focus mouse && yabai -m window --toggle zoom-fullscreen \n
	cmd - 0x2C : yabai -m space --gap rel:10 \n
	cmd - 0x18 : yabai -m space --gap rel:-10 \n
	cmd + shift - 0 : yabai -m space --balance \n
	cmd + ctrl - left : yabai -m window --swap west \n
	cmd + ctrl - down : yabai -m window --swap south \n
	cmd + ctrl - up : yabai -m window --swap north \n
	cmd + ctrl - right : yabai -m window --swap east \n
	cmd + shift - left : yabai -m window --warp west \n
	cmd + shift - down : yabai -m window --warp south \n
	cmd + shift - up : yabai -m window --warp north \n
	cmd + shift - right : yabai -m window --warp east \n
	cmd + alt - 1 : yabai -m window --space 1 \n
	cmd + alt - 2 : yabai -m window --space 2 \n
	cmd + alt - 3 : yabai -m window --space 3 \n
	cmd + alt - 4 : yabai -m window --space 4 \n
	cmd + alt - 5 : yabai -m window --space 5 \n
	cmd + alt - 6 : yabai -m window --space 6 \n
	cmd + alt - 7 : yabai -m window --space 7 \n
	cmd + alt - 8 : yabai -m window --space 8 \n
	cmd + alt - 9 : yabai -m window --space 9 \n
	cmd + alt - 0 : yabai -m window --space 10 \n
	cmd + alt - 0x2c : yabai -m space --layout bsp \n
	cmd + alt - 0x18 : yabai -m space --layout float \n
	cmd + alt - č : yabai -m window --resize left:-40:0 \n
	cmd + alt - ć : yabai -m window --resize right:40:0 \n
	cmd + alt - š : yabai -m window --resize bottom:0:40 \n
	cmd + alt - đ : yabai -m window --resize top:0-40 \n
	cmd + ctrl - č : yabai -m window --resize left:40:0 \n
	cmd + ctrl -ć : yabai -m window --resize right:-40:0 \n
	cmd + ctrl - š : yabai -m window --resize bottom:0:-40 \n
	cmd + ctrl - đ : yabai -m window --resize top:0:40 \n
      ";
    };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Backwards compatibility (read changelog b4 changin)
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#coolflake
    darwinConfigurations."coolflake" = nix-darwin.lib.darwinSystem {
      modules = [
	configuration
	nix-homebrew.darwinModules.nix-homebrew
	{
	  nix-homebrew = {
	    enable = true;
	    # User who owns homebrew:
	    user = "Ian";
	  };
	}
      ];
    };
  };
}
