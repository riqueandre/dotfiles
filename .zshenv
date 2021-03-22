typeset -U PATH path
path=(~/.bin ~/.local/bin ~/.local/scripts ~/.local/scripts/bspwm $path[@] )
export PATH

export EDITOR='nvim'
export BROWSER='google-chrome-stable'
export TERMCMD='alacritty'

if [ "$XDG_SESSION_DESKTOP" = "bspwm" ]; then
    export _JAVA_AWT_WM_NONREPARENTING=1
fi
