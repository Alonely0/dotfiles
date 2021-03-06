# if perl -lpe 's/\0/ /g' /proc/$(xdotool getwindowpid $(xdotool getactivewindow))/cmdline | grep "edex-ui"
# then
# 	cp -f ~/.p10k.zsh.EDEX-UI ~/.p10k.zsh
# else
# 	cp -f ~/.p10k.zsh.ALACRITTY ~/.p10k.zsh
# fi

## Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
## Initialization code that may require console input (password prompts, [y/n]
## confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.gem/ruby/2.7.0/bin:$PATH

## Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

## Set name of the theme to load --- if set to "random", it will
## load a random theme each time oh-my-zsh is loaded, in which case,
## to know which specific one was loaded, run: echo $RANDOM_THEME
## See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

## IBUS
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

## Set list of themes to pick from when loading at random
## Setting this variable when ZSH_THEME=random will cause zsh to load
## a theme from this variable instead of looking in $ZSH/themes/
## If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

## Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

## Uncomment the following line to use hyphen-insensitive completion.
## Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

## Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

## Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

## Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1

## Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

## Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

## Uncomment the following line to disable auto-setting terminal title.
## DISABLE_AUTO_TITLE="true"

## Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

## Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

## Uncomment the following line if you want to disable marking untracked files
## under VCS as dirty. This makes repository status check for large repositories
## much, much faster.
## DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
## "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
## or set a custom format using the strftime function format specifications,
## see 'man strftime' for details.
## HIST_STAMPS="mm/dd/yyyy"

## Would you like to use another custom folder than $ZSH/custom?
## ZSH_CUSTOM=/path/to/new-custom-folder

## Which plugins would you like to load?
## Standard plugins can be found in $ZSH/plugins/
## Custom plugins may be added to $ZSH_CUSTOM/plugins/
## Example format: plugins=(rails git textmate ruby lighthouse)
## Add wisely, as too many plugins slow down shell startup.
plugins=(
	git	
	zsh-autosuggestions
	zsh-syntax-highlighting
	command-not-found
)

source $ZSH/oh-my-zsh.sh

## User configuration

export MANPATH="/usr/local/man:$MANPATH"

## You may need to manually set your language environment
export LANG=en_US.UTF-8

## Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

## Compilation flags
export ARCHFLAGS="-arch x86_64"


## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

## Bindings
# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

alias zconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias color="asusctl led-mode"
alias fusuma="$HOME/.gem/ruby/2.7.0/bin/fusuma"
alias pycritty=".config/alacritty/pycritty/src/main.py"
alias mount-btrfs="doas mount -o noatime,space_cache,autodefrag,compress=zstd"
alias pip="python3 -m pip"
alias pip3="python3 -m pip"
alias todo="todo.sh"
alias -s txt="nvim"
alias grubup="doas update-grub"
alias orphaned="doas pacman -Rns $(pacman -Qtdq)"
alias fixpacman="doas rm /var/lib/pacman/db.lck"
alias untar='tar -zxvf '
alias wget='wget -c '
alias cp="cp -r"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias path='echo -e ${PATH//:/\\n}'

whervim()
{
	nvim $(where $1)
}

update()
{
	paru -Syyu
	xmonad --recompile
	npm install
	doas npm install -g npm
	pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
	doas gem update
	rustup update
  mkinitcpio -P
	doas grub-mkconfig -o /boot/grub/grub.cfg
}

## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

tuxfetch

function prompt_my_cpu_temp() {
	integer cpu_temp="$(</sys/class/thermal/thermal_zone0/temp) / 1000"
        if (( cpu_temp >= 70 )); then
                p10k segment -s HOT -f red -i '' -t "${cpu_temp}ºC"
		# rog-core -f boost (commented because only is usable on old rog laptops)
		# asusctl -f boost # Recommended on newer rog laptops
        elif (( cpu_temp >= 41 )); then
                p10k segment -s WARM -f yellow -i '' -t "${cpu_temp}ºC"
		# rog-core -f boost (commented because only is usable on old rog laptops)
                # asusctl -f normal # Recommended on newer rog laptops
        elif (( cpu_temp <= 40 )); then
		p10k segment -s COLD -f blue -i '' -t "${cpu_temp}ºC"
		# rog-core -f boost (commented because only is usable on old rog laptops)
                # asusctl -f silent # Recommended on newer rog laptops
        fi
}

function prompt_my_separator() {
  p10k segment -f white -i '-' -t ""
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
