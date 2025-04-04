{ pkgs, ... }:
{
  ## Enable fish
  users.defaultUserShell = pkgs.bash;
  environment.shells = [
    pkgs.bash
    pkgs.fish
  ];
  environment.systemPackages = with pkgs; [
    atuin
    babelfish
    starship
    thefuck
    yazi
    zoxide
  ];

  # Use bash as system shell, and only use fish in interactive sessions
  programs.bash = {
    interactiveShellInit = "exec fish";
  };

  # Fish options
  programs.fish = {
    enable = true;
    useBabelfish = true;
    shellAbbrs = {
      clearls = "clear && eza -al -I .git";
      ls = "eza -al -I .git";
      archive = "tar -czvf archive.tar.gz ";
      extract = "tar -xzvf ";
      so = "exec fish";
      lanscan = "seq 254 | xargs -i IP -P 255 ping -c 1 192.168.2.IP | rg time= | arp -a";
    };

    interactiveShellInit = ''
      # Colors
      set -Ux fish_initialized 3400
      set -Ux fish_color_autosuggestion 666
      set -Ux fish_color_cancel \x2d\x2dreverse
      set -Ux fish_color_command 00ff00
      set -Ux fish_color_comment 888\x1e\x2d\x2ditalics
      set -Ux fish_color_cwd 0A0
      set -Ux fish_color_cwd_root A00
      set -Ux fish_color_end ffff00
      set -Ux fish_color_error F22
      set -Ux fish_color_escape 0AA
      set -Ux fish_color_history_current 0AA
      set -Ux fish_color_host normal
      set -Ux fish_color_host_remote \x1d
      set -Ux fish_color_keyword \x1d
      set -Ux fish_color_match 0AA
      set -Ux fish_color_normal B2B2B2
      set -Ux fish_color_operator 0AA
      set -Ux fish_color_option \x1d
      set -Ux fish_color_param 0087d7
      set -Ux fish_color_quote ffd75f
      set -Ux fish_color_redirection 00ffd7
      set -Ux fish_color_search_match \x2d\x2dbackground\x3d533
      set -Ux fish_color_selection \x2d\x2dbackground\x3dB218B2
      set -Ux fish_color_status red
      set -Ux fish_color_user brgreen
      set -Ux fish_color_valid_path \x2d\x2dunderline
      set -Ux fish_key_bindings fish_default_key_bindings
      set -Ux fish_pager_color_background \x1d
      set -Ux fish_pager_color_completion BBB
      set -Ux fish_pager_color_description 666
      set -Ux fish_pager_color_prefix 0AA\x1e\x2d\x2dunderline
      set -Ux fish_pager_color_progress 0AA
      set -Ux fish_pager_color_secondary_background \x1d
      set -Ux fish_pager_color_secondary_completion \x1d
      set -Ux fish_pager_color_secondary_description \x1d
      set -Ux fish_pager_color_secondary_prefix \x1d
      set -Ux fish_pager_color_selected_background \x2d\x2dbackground\x3d333
      set -Ux fish_pager_color_selected_completion \x1d
      set -Ux fish_pager_color_selected_description \x1d
      set -Ux fish_pager_color_selected_prefix \x1d

      # VI mode
      fish_vi_key_bindings
      set -Ux fish_cursor_default block
      set -Ux fish_cursor_insert line
      set -Ux fish_cursor_replace underscore
      set -Ux fish_cursor_replace_one underscore

      # shell inits
      function starship_transient_prompt_func
        starship module character
      end
      starship init fish | source
      enable_transience
      atuin init fish | source
      direnv hook fish | source
      chezmoi completion fish | source
      just --completions fish | source
      nh completions --shell fish | source
      thefuck --alias | source

      # Misc variables
      set -Ux HOSTNAME $(hostname)
      set -Ux FLAKE $HOME/NixOS-Config
      set -Ux MANPAGER 'nvim +Man!'
    '';
  };

  hm = {
    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
      "$HOME/.cargo/bin"
      "/home/linuxbrew/.linuxbrew/bin"
      "/home/linuxbrew/.linuxbrew/sbin"
      "$HOME/.nix-profile/bin"
    ];

    # Atuin
    programs.atuin = {
      enable = true;
      settings = {
        update_check = false;
        filter_mode = "session";
        workspaces = true;
        style = "auto";
        exit_mode = "return-query";
        ctrl_n_shortcuts = false;
        enter_accept = true;
        keymap_mode = "vim-insert";
      };
    };
  };
}
