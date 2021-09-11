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
" Using :term
nnoremap <leader><leader>m :Telegraph man
" Using a tmux popup
noremap <leader><leader>M :lua require'telegraph'.telegraph({how='tmux_popup', cmd='man '})<Left><Left><Left>
```

lookatme slides

```
" lookatme in a terminal
nnoremap <leader><leader>s :Telegraph pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark<cr>
" lookatme in a tmux popup
nnoremap <leader><leader>S :lua require'telegraph'.telegraph({cmd='pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux_popup'})<CR>
```

## how

Telegraph 

* **term**(default) runs command in the built in terminal
* **tmux** runs command in a new tmux session and joins it.
* **tmux_popup** runs command in a tmux popup window.
* **tmux_popup_session** runs command in a tmux session and displays it in a popup

## format strings

Telegraph will replace the following variables enclosed in braces.

* cword
* cWORD
* filepath
* filename
* parent
* current_session_name
* cwd


```
:Telegraph ls {parent}
:Telegraph cat {filename}
:Telegraph man {cword}
:Telegraph vd {cWORD}
```


