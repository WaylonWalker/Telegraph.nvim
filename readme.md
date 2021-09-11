Telegraph.nvim provides a way to send command conveniently and bind them to hotkeys.

## The Problem

I want to bind hotkeys to run shell commands with context about my current
file, line, word, or working directory without parsing all of that each time I
want to make a new binding.

## The other Problem

I often want these commands sent to a tmux session that I can get to quickly.
Doing this often requires the same couple of lines that is more than a single
line.


## Installation

``` vim
Plug waylonwalker/Telegraph.nvim
```

## Example usage

Man Page Searcher

``` vim
nnoremap <leader><leader>m :Telegraph man
```

lookatme slides

```
nnoremap <leader><leader>S :Telegraph lua require'telegraph'.telegraph({cmd='pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux_popup'})")
nnoremap <leader><leader>s :Telegraph pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark<cr>
```

## how


* **term**(default)
* **tmux** runs command in a new tmux session and joins it.
* **tmux_popup** runs command in a tmux popup window.
* **tmux_popup_session** runs command in a tmux session and displays it in a popup

## format strings

Telegraph will replace


* cword
* cWORD
* filepath
* filename
* parent


