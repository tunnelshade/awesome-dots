" Basic editor stuff
set number          " show line numbers
set nofoldenable    " disable folding
set nowrap
set modelines=1
set sidescroll=10    " horizontal scrolling by character
set relativenumber             " relative numbering
set shell=fish
set colorcolumn=120

set exrc
set secure

set nocompatible              " be iMproved, required
filetype off                  " required

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
" Display all matching files when we tab complete
set wildmenu

" ctags command
command! MakeTags !ctags -R --extra=+f --python-kinds=-iv .

" Vundle stuff
" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

" Airline instead of powerline, simple yet great
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'

Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'

if isdirectory('/usr/local/opt/fzf')
	Plug '/usr/local/opt/fzf'
endif
Plug 'junegunn/fzf.vim'
Plug 'miki725/vim-ripgrep'
" https://github.com/jremmen/vim-ripgrep/issues/41
" Plug 'jremmen/vim-ripgrep'

" Completing engine
Plug 'ervandew/supertab'
Plug 'Valloric/YouCompleteMe'

Plug 'tpope/vim-surround'

" Snippets are the love of my life
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-emoji'

" PEP-8 compliance help
Plug 'w0rp/ale'
Plug 'nvie/vim-flake8'
" Plugin 'klen/python-mode'

" DVCS : Git, gitgutter for showing the changes beside line numbers
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'majutsushi/tagbar'

" Writing
Plug 'junegunn/goyo.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/limelight.vim'

call plug#end()
syntax on
filetype plugin indent on    " required

" Set encoding
set encoding=utf-8
set backspace=2  " osx fix

" Airline Hacks
set laststatus=2                              " without this the status line is not visible
set ttimeoutlen=50                            " to prevent delay when leaving insert mode
let g:airline_powerline_fonts=1               " using patched Inconsolata
let g:airline_theme='powerlineish'            " favourite theme
let g:airline#extensions#tabline#show_buffers=1
let g:rehash256=1

" Colorscheme
colorscheme gruvbox
set background=dark

" Search customisations
set hlsearch incsearch ignorecase " highlight search, incremental search and ignore case
" double escape for removing search highlights
nnoremap <silent> <Esc><Esc> :let @/=""<CR>

" File specific hacks
autocmd Filetype python set expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype htmldjango set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype html set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype yaml set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype javascript set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype markdown set expandtab tabstop=2 shiftwidth=2 softtabstop=2

let blacklist = ['markdown']
autocmd BufWritePre * if index(blacklist, &ft) < 0 | :%s/\s\+$//e

" Backup locations
set backup
set backupdir=~/.vim/backup
set directory=/tmp

" Splitfu
" Just navigate around splits vim way
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"" Ultisnips
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:UltiSnipsExpandTrigger = "<C-e>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:ultisnips_python_style="google"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/plugged/vim-snippets/UltiSnips']

" Lint Engine
let g:ale_sign_warning="⚠"
let g:ale_sign_error="x"
let g:airline#extensions#ale#error_symbol="x"
let g:airline#extensions#ale#warning_symbol="⚠ "
nmap <silent> [l <Plug>(ale_previous_wrap)
nmap <silent> ]l <Plug>(ale_next_wrap)
highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_lint_on_save=1  " Run lint only on save
let g:ale_lint_on_text_changed=0
let g:ale_rust_cargo_check_tests=1
let g:ale_rust_rls_toolchain="stable"
let g:ale_python_pyls_use_global=1
let g:ale_linters = {'rust': ['rls']}
let g:ale_completion_enabled = 1

" netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25

" CtrlP
let g:ctrlp_map = '<c-p>'

" FZF
map ; :Files<CR>

" Markbar
map ' :Marks<CR>


" Sudo write
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Ripgrep
let g:rg_command="rg --vimgrep -g !tags -g '!*.{min,zip,swp}' -g '!.git/*' "

" Tagbar
nmap <F8> :TagbarToggle<CR>
" autocmd VimEnter * nested :call tagbar#autoopen(1)

" Custom functions
function! Beautify()
	if (&filetype == "javascript") || (&filetype == "json")
		execute "%!js-beautify"
	else
		execute "%!clang-format"
	endif
endfunction

" Text justifying
ru macros/justify.vim

" Writing
let g:goyo_width = 120
let g:goyo_height = '90%'
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Custom commands
command Beautify :call Beautify()

" Emoji
augroup emoji_complete
	autocmd FileType markdown setlocal completefunc=emoji#complete
augroup END
nmap <F9> :%s/:\([^:]\+\):/\=emoji#for(submatch(1),submatch(0))/g<CR>

" YCM LSP
let g:ycm_language_server = [
			\  {
			\   'name': 'python',
			\   'cmdline': ['pyls'],
			\   'filetypes': ['python']
			\  },
			\  {
			\   'name': 'rust',
			\   'cmdline': ['rls'],
			\   'filetypes': ['rust']
			\  }
\ ]
