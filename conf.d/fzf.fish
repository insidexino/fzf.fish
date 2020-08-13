# Set up the default, mnemonic keybindings unless the user has chosen to customize them
if not set --query fzf_fish_custom_keybindings
    # \cf is ctrl+f, etc.
    bind \cf '__fzf_search_current_dir'
    bind \cl '__fzf_search_git_log'
    bind \cr '__fzf_search_history'
    bind \cv '__fzf_search_shell_variables'

    # set up the same keybindings for insert mode if using fish_vi_key_bindings
    if [ $fish_key_bindings = 'fish_vi_key_bindings' ]
        bind --mode insert \cf '__fzf_search_current_dir'
        bind --mode insert \cl '__fzf_search_git_log'
        bind --mode insert \cr '__fzf_search_history'
        bind --mode insert \cv '__fzf_search_shell_variables'
    end
end

# If FZF_DEFAULT_OPTS is not set, then set some sane defaults. This also affects fzf outside of this plugin.
# See https://github.com/junegunn/fzf#environment-variables
if not set --query FZF_DEFAULT_OPTS
    # cycle makes scrolling easier
    # reverse layout is more familiar as it mimicks the layout of git log, history, and env
    # border makes clear where the fzf window ends
    # height 75% allows you to view what you were doing and stay in context of your work
    set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height 75%'
end

# In case fzf_fish_custom_keybindings is set AFTER the default keybindings have already been
# set, use an event handler to erase bindings if it fzf_fish_custom_keybindings gets changed
# For documentation on event handlers, see https://fishshell.com/docs/current/#event
function erase_default_bindings --on-variable fzf_fish_custom_keybindings
    bind --erase --all \cf
    bind --erase --all \cl
    bind --erase --all \cr
    bind --erase --all \cv
end

function fzf_uninstall --on-event fzf_uninstall
    if not set --query fzf_fish_custom_keybindings
        erase_default_bindings
        set_color --italics cyan
        echo "fzf.fish key kindings removed"
        set_color normal
    end
    # Not going to erase FZF_DEFAULT_OPTS because too hard to tell if it's set by the user or by this plugin
end
