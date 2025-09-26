function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function vf() {
    fzf | xargs -r -d '\n' nvim
}

alias pamcan='pacman'
alias ls='eza --icons'
alias clear="printf '\033[2J\033[3J\033[1;1H'"

# List Directory
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias vc='code'

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias mkdir='mkdir -p'

alias v='nvim'
alias n='neovide'
# alias vk='NVIM_APPNAME="nvim-kickstart" nvim'
alias h='helix'
alias phpmyadmin='docker run -d --name myphpmyadmin -e PMA_HOST=host.containers.internal -p 8080:80 docker.io/phpmyadmin/phpmyadmin'
alias t='tmux'
alias rt='tmux kill-server && tmux || tmux'
alias s='source ~/.bashrc' # Changed to source ~/.bashrc for bash
alias gemini='npx https://github.com/google-gemini/gemini-cli'
alias tl='tldr'
alias laravel="~/.config/composer/vendor/bin/laravel"
alias gt="~/Projects-to-plays/ghostty/zig-out/bin/ghostty"
# alias docker='podman'
# alias docker-compose='podman-compose'
alias ze='zellij'
alias bo='bongocat --config ~/.config/bongocat.conf'
alias ld='lazydocker'
alias gi='gitui'
alias ii='nautilus .'
alias ll='ls -l'
alias b='bat'
alias acli='/home/dwcks/works-projects/acli'
# alias air='/home/dwcks/go/bin/air'
alias sqls='/home/dwcks/go/bin/sqls'
alias dbee='/home/dwcks/go/bin/dbee'
alias la='eza -lTag --header --hyperlink --git --icons'
alias l3='eza -lTaL3 --header --hyperlink --git --icons'
alias l2='eza -lTaL2 --header --hyperlink --git --icons'
alias l1='eza -TaL1 --header --hyperlink --icons'
# alias l='eza --icons --header --hyperlink --git -lTL'
alias lz='lazygit'
alias m='make'
alias c='cargo'
alias g='go'
alias no='node'
alias cl='clear'
