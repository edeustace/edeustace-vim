set lines=80
set columns=203
set guifont=Monaco:h11
set number
syntax on
set guioptions-=T
set tabstop=2       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " vim will interpret it to be having
                    " a width of 4.

set shiftwidth=2    " Intents will have a width of 4

set softtabstop=2   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces


if has("gui_mac") || has("gui_macvim")
  macmenu &File.New\ Tab     key=<Nop>
  map <silent><D-t> :FufFile **/<CR>
endif

    
setlocal display=uhex
set lcs=tab:>\ ,eol:¬,spc:_,nbsp:%
"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59
 
