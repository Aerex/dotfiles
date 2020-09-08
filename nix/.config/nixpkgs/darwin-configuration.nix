{ config, pkgs, ... }:


{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    nvim
    neomutt
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  services = {
    yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = true;
      config = {
        focus_follows_mouse          = "autoraise";
        mouse_follows_focus          = "off";
        window_placement             = "second_child";
        window_opacity               = "off";
        window_opacity_duration      = "0.0";
        window_topmost               = "on";
        window_shadow                = "float";
        active_window_opacity        = "1.0";
        active_window_border_color   = "0xffD6B1A0"
        normal_window_opacity        = "1.0";
        split_ratio                  = "0.50";
        auto_balance                 = "on";
        mouse_modifier               = "fn";
        mouse_action1                = "move";
        mouse_action2                = "resize";
        layout                       = "bsp";
        top_padding                  = 36;
        bottom_padding               = 10;
        left_padding                 = 10;
        right_padding                = 10;
        window_gap                   = 10;
      };

      extraConfig = ''
        source ~/.cache/wal/chunkwmcolors
        yabai -m config 
        # rules
        #yabai -m rule --add app='System Preferences' manage=off

        # Any other arbitrary config here
      '';

    };

    skhd = {
      enable = true;
      skhdConfig = ''
          # focus window
          cmd - h : yabai -m window --focus west
          cmd - j : yabai -m window --focus south
          cmd - k : yabai -m window --focus north
          cmd - l : yabai -m window --focus east

          cmd + shift - j : yabai -m window -focus prev
          cmd + shift - k : yabai -m window -focus next

          # swap managed window
          cmd + alt - h : yabai tiling::window --swap west
          cmd + alt - j : yabai tiling::window --swap south
          cmd + alt - k : yabai tiling::window --swap north
          cmd + alt - l : yabai tiling::window --swap east

          # shift + alt - h : yabai -m window --swap north

          # move managed window
          # shift + cmd - h : yabai -m window --warp east
          shift + cmd - h : yabai -m window --warp west
          shift + cmd - j : yabai -m window --warp south
          shift + cmd - k : yabai -m window --warp north
          shift + cmd - l : yabai -m window --warp east

          # balance size of windows / equalize size of windows
           shift + alt - 0 : yabai -m space --balance

          # make floating window fill screen
           shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1

          # make floating window fill left-half of screen
           shift + alt - left   : yabai -m window --grid 1:2:0:0:1:1


          # fast focus desktop
          # cmd + alt - x : yabai -m space --focus recent
          # cmd + alt - 1 : yabai -m space --focus 1

          # send window to desktop 
          #shift + cmd - x : yabai -m window --space $(yabai get _last_active_desktop)
          cmd + shift - z : yabai -m window --space prev
          cmd + shift - c : yabai -m window --space next
          cmd + shift - 1 : yabai -m window --space 1
          cmd + shift - 2 : yabai -m window --space 2
          cmd + shift - 3 : yabai -m window --space 3
          cmd + shift - 4 : yabai -m window --space 4
          cmd + shift - 5 : yabai -m window --space 5
          cmd + shift - 6 : yabai -m window --space 6
          cmd + shift - 7 : yabai -m window --space 7
          cmd + shift - 8 : yabai -m window --space 8
          # shift + cmd - z : yabai -m window --space next; yabai -m space --focus next
          #
          # rotate tree
          # Rotate the window tree clock-wise (options: 90, 180, 270 degree)
                    alt - r : yabai -m space --rotate 90 
          # shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2

          # focus monitor
          # ctrl + alt - z  : yabai -m display --focus prev
          # ctrl + alt - 3  : yabai -m display --focus 3

          # send window to monitor and follow focus
          # ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
          # ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1

          # move floating window
          # shift + ctrl - a : yabai -m window --move rel:-20:0
          # shift + ctrl - s : yabai -m window --move rel:0:20

          # increase window size
          # shift + alt - a : yabai -m window --resize left:-20:0
          # shift + alt - w : yabai -m window --resize top:0:-20

          # decrease window size
          # shift + cmd - s : yabai -m window --resize bottom:0:-20
          # shift + cmd - w : yabai -m window --resize top:0:20

          # set insertion point in focused container
          # ctrl + alt - h : yabai -m window --insert west

          # toggle window zoom
                     alt - d : yabai -m window --toggle zoom-parent
                     alt - f : yabai -m window --toggle zoom-fullscreen

          # toggle window split type
          # alt - e : yabai -m window --toggle split

          # float / unfloat window and center on screen
          # alt - t : yabai -m window --toggle float;\
          #           yabai -m window --grid 4:4:1:1:2:2

          # toggle sticky(+float), topmost, picture-in-picture
          # alt - p : yabai -m window --toggle sticky;\
              #           yabai -m window --toggle topmost;\
              #           yabai -m window --toggle pip
          # change layout of desktop
          cmd + shift - b : yabai -m space --layout bsp
          cmd + shift - m : yabai -m space --layout monocle
          cmd + shift - n : yabai -m space float 

      '';

    };
  };
}

