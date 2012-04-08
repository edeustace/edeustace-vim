
" Autoload (pathogen) {
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" }

" Environment {
  " Basics {
    set bg=dark
    syntax on
    set title
    set nocompatible
  " }
  " Windows Compatible {
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier. 
    if has('win32') || has('win64')
      set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    endif
  " }
" }

" Formatting {
	set nowrap                     	" wrap long lines
	set autoindent                 	" indent at the same level of the previous line
	set shiftwidth=2               	" use indents of 4 spaces
	set expandtab 	  	     		" tabs are spaces, not tabs
	set tabstop=2 					" an indentation every four columns
	set softtabstop=2 				" let backspace delete indent
	"set matchpairs+=<:>            	" match, to be used with % 
	set pastetoggle=<F12>          	" pastetoggle (sane indentation on pastes)
	"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
	" Remove trailing whitespaces and ^M chars
	autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" }

" General {
  filetype on
  filetype plugin on
  set nobackup       "no backup files
  set nowritebackup  "only in case you don't want a backup file while editing
  set noswapfile     "no swap files
  set ofu=syntaxcomplete#Complete
  set background=dark         " Assume a dark background
"  if !has('win32') && !has('win64')
"     set term=$TERM       " Make arrow and other keys work
"  endif
  filetype plugin indent on    " Automatically detect file types.
  syntax on           " syntax highlighting
  set mouse=a          " automatically enable mouse usage
  "set autochdir         " always switch to the current file directory.. Messes with some plugins, best left commented out
  " not every vim is compiled with this, use the following line instead
  " If you use command-t plugin, it conflicts with this, comment it out.
     "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
  scriptencoding utf-8

  " set autowrite                  " automatically write a file when leaving a modified buffer
  set shortmess+=filmnrxoOtT       " abbrev. of messages (avoids 'hit enter')
  set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
  set virtualedit=onemore        " allow for cursor beyond last character
  
  set spell                  " spell checking on

  " Setting up the directories {
    "set backup             " backups are nice ...
    " Moved to function at bottom of the file
    "set backupdir=$HOME/.vimbackup//  " but not when they clog .
    "set directory=$HOME/.vimswap//   " Same for swap files
    "set viewdir=$HOME/.vimviews//   " same for view files

    "" Creating directories if they don't exist
    "silent execute '!mkdir -p $HVOME/.vimbackup'
    "silent execute '!mkdir -p $HOME/.vimswap'
    "silent execute '!mkdir -p $HOME/.vimviews'
    au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
    au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
  " }
" }

" User Input {
" Map ctrl-movement keys to window switching
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

" }

" Vim UI {
  colorscheme darker-robin                " load a colorscheme
  set tabpagemax=15         " only show 15 tabs
  set showmode                     " display the current mode

  set cursorline          " highlight current line
  hi cursorline guibg=#333333   " highlight bg color of current line
  hi CursorColumn guibg=#333333   " highlight cursor

  if has('cmdline_info')
    set ruler                    " show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd                  " show partial commands in status line and
                  " selected characters/lines in visual mode
  endif

  if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    " set statusline+=%{fugitive#statusline()} "  Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " filetype
    set statusline+=\ [%{getcwd()}]          " current dir
    " set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  endif

  set backspace=indent,eol,start  " backspace for dummys
  set linespace=0          " No extra spaces between rows
  set nu              " Line numbers on
  set showmatch          " show matching brackets/parenthesis
  set incsearch          " find as you type search
  set hlsearch          " highlight search terms
  set winminheight=0        " windows can be 0 line high 
  set ignorecase          " case insensitive search
  set smartcase          " case sensitive when uc present
  set wildmenu          " show list instead of just completing
  set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
  set whichwrap=b,s,h,l,<,>,[,]  " backspace and cursor keys wrap to
  set scrolljump=5         " lines to scroll when cursor leaves screen
  set scrolloff=3         " minimum lines to keep above and below cursor
  set foldenable          " auto fold code
  set gdefault          " the /g flag on :s substitutions by default
  set list
  set listchars=tab:>.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
" }

" FileType Checking and Syntax checking {
    augroup filetypedetect
        au! BufRead,BufNewFile *.pp     setfiletype puppet
        au! BufRead,BufNewFile *httpd*.conf     setfiletype apache
        au! BufRead,BufNewFile *inc     setfiletype php
        au! BufRead,BufNewFile Gemfile     setfiletype ruby
        au! BufRead,BufNewFile *.thor     setfiletype ruby
    augroup END

    " Uncomment these lines to do syntax checking when you save
    augroup Programming
    " clear auto commands for this group
    autocmd!
    autocmd BufWritePost *.php !php -d display_errors=on -l <afile>
    autocmd BufWritePost *.inc !php -d display_errors=on -l <afile>
    autocmd BufWritePost *httpd*.conf !/etc/rc.d/init.d/httpd configtest
    autocmd BufWritePost *.bash !bash -n <afile>
    autocmd BufWritePost *.sh !bash -n <afile>
    autocmd BufWritePost *.pl !perl -c <afile>
    autocmd BufWritePost *.perl !perl -c <afile>
    autocmd BufWritePost *.xml !xmllint --format --recover --noout <afile>
    autocmd BufWritePost *.xsl !xmllint --format --recover --noout <afile>
    " get csstidy from http://csstidy.sourceforge.net/
    autocmd BufWritePost *.css !test -f ~/csstidy/csslint.php && php ~/csstidy/csslint.php <afile>
    " get jslint from http://javascriptlint.com/
    autocmd BufWritePost *.js !test -f ~/jslint/jsl && ~/jslint/jsl -conf ~/jslint/jsl.default.conf -nologo -nosummary -process <afile>
    autocmd BufWritePost *.rb !ruby -c <afile>
    autocmd BufWritePost *.pp !puppet --parseonly <afile>
    autocmd BufWritePost *.erb !erb -x -T '-' <afile> | ruby -c 
    autocmd BufWritePost *.py !python -c "compile(open('<afile>').read(), '<afile>', 'exec')"
    augroup en
" }
"
" {{{ Hide Toolbar in macvim
  if has("gui_running")
      set guioptions=egmrt
  endif
" }}}
"

" {{{ Single character insertion
" When you only want to insert a single character you don't want to use 3
" keystrokes. This command allows you to type s in command mode - insert the
" character and then jumps out to command mode.
" from: http://vim.wikia.com/wiki/Insert_a_single_character
function! RepeatChar(char, count)
   return repeat(a:char, a:count)
 endfunction
 nnoremap s :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
 nnoremap S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>
" }}}


" {{{ Autocompletion using the TAB key

" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
"function InsertTabWrapper()
"    let col = col('.') - 1
"   if !col || getline('.')[col - 1] !~ '\k'
"        return "\<tab>"
"    else
"        return "\<c-p>"
"    endif
"endfunction

" Remap the tab key to select action with InsertTabWrapper
" inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" }}} Autocompletion using the TAB key


