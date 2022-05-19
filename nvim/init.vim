set shell=/bin/zsh
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" =============================================================================
set nocompatible
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME}/nvim/autoload/plug.vim"'))
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif
call plug#begin(system('echo -n "${XDG_CONFIG_HOME}/nvim/plugged"'))

Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.local/fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'pangloss/vim-javascript'
Plug 'mattn/emmet-vim'

Plug 'tpope/vim-surround'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plug 'dense-analysis/ale'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'elzr/vim-json'
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'

" LateX
Plug 'vim-latex/vim-latex'

" Solidity
Plug 'ethereum/vim-solidity'

call plug#end()

if !has('gui_running')
	set t_Co=256
endif
if has("termguicolors")
  set termguicolors
endif

if executable('rg')
  let g:rg_derive_root='true'
endif

set background=dark
colorscheme base16-gruvbox-dark-hard
hi Normal ctermbg=NONE
" Get syntax
syntax on

if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit
    noremap <C-q> :confirm qall<CR>
end
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

set completeopt=menuone,noinsert,noselect

" Lightline

function! LightlineFilename()
	return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

function! CurrentFunction()
	return get(b:, "coc_current_function", "")
endfunction

let g:lightline = {
	\ 'active':{
	\ 	'left':[ ['mode', 'paste'],
	\ 	['gitbranch','readonly', 'filename', 'modified', 'currentfunction', 'status' ] ],
	\
	\ 	'right':[ ['lineinfo'],
	\ 		['percent'],
	\ 		['fileencoding', 'filetype'] ]
	\ },
      	\ 'colorscheme': 'wombat', 
      	\ 'component_function': {
      	\   'filename': 'LightlineFilename',
	\   'gitbranch': 'gitbranch#name',
	\   'currentfunction':'CurrentFunction',
	\   'status': 'coc#status'
      	\ },
\ }

" Coc navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <leader>l <Plug>(coc-diagnostic-info)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gdd <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> grr <Plug>(coc-rename)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Tab for navigation
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use `:OR` for organize import of current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Prettier :CocCommand prettier.formatFile


" Emmet
let g:user_emmet_leader_key=','

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set autoindent
set timeoutlen=300 
set encoding=utf-8
set scrolloff=2
set noshowmode " Lightline shows the mode instead
set hidden
set nowrap
set nojoinspaces
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
set splitright
set splitbelow
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

" Permanent undo
set noswapfile
set nobackup
set undodir=~/.vimdid
set undofile

" Decent wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" Continue where left off
if has("autocmd")
 au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" =============================================================================
" # GUI settings
" =============================================================================
set guioptions-=T " No toolbar
set vb t_vb= " No beeps
set backspace=2 " Backspace over newlines
set nofoldenable
set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber " Relative line numbers
set number " Current absolute line
set diffopt+=iwhite " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

highlight ColorColumn ctermbg=lightred ctermfg=black guibg=lightred guifg=black
" so that split windows also show color column
augroup c_column
  autocmd!
  autocmd WinEnter * call clearmatches()
  autocmd VimEnter,WinEnter * call matchadd('ColorColumn', '\%81v', 100)
augroup END

set showcmd " Show (partial) command in status line.
set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages.

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" display whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.rs,*.cpp,*.h,*.js,*.ts  match BadWhitespace /\s\+$/

" JSON
au! BufRead,BufNewFile *.json set filetype=json

" *script
"autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
au BufNewFile,BufRead *.vue set tabstop=2 softtabstop=2 shiftwidth=2 textwidth=80 expandtab autoindent fileformat=unix 
au BufNewFile,BufRead *.html,*.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent fileformat=unix 

" C/C++
autocmd FileType c,h,cpp setlocal equalprg=clang-format
function! Formatonsave()
  	let l:formatdiff = 1
	py3f /usr/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.c,*.cpp call Formatonsave()

" Copy into clipboard
xnoremap <silent> <leader>c :w !wl-copy -n <cr><cr>
noremap <leader>v :read !wl-paste -n -t STRING<cr><cr>

" Quick access files
map <C-p> :GFiles<CR>
nmap <leader>; :Buffers<CR>

" Quick-save
nmap <leader>w :w<CR>

" Format selected block of HTML code
noremap <leader>f :'<,'>! prettier --parser html --stdin-filepath<cr>

" =============================================================================
" # Footer
" =============================================================================
" nvim
if has('nvim')
	runtime! plugin/python_setup.vim
endif
