local return_code="%B%(?..%{$fg[red]%}%? ↵%{$reset_color%})%b"
local user_host="%B%(!.%{$fg[red]%}.%{$fg[green]%})%n@%m%{$reset_color%} "
local user_symbol='%B%(!.#.$)%b'
local current_dir='%{$terminfo[bold]$fg[blue]%}%c %{$reset_color%}'

PROMPT="╭─${user_host}${current_dir}${return_code}
╰─${user_symbol} "
