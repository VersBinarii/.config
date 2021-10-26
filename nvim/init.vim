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

" Load plugins

Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.local/fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'pangloss/vim-javascript'
Plug 'mattn/emmet-vim'

" Python
Plug 'vim-scripts/indentpython.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'nvie/vim-flake8'

Plug 'tpope/vim-surround'


Plug 'neovim/nvim-lspconfig'
" Completion framework
Plug 'hrsh7th/nvim-cmp'
" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'
" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
" See hrsh7th's other plugins for more completion sources!
" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'
" Snippet engine
Plug 'hrsh7th/vim-vsnip'

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

" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'
local on_attach = function(client, bufnr)
    local function
        buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function
        buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...)
    end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    server = {
	on_attach = on_attach,
        settings = {
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

require('rust-tools').setup(opts)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

" Lightline

function! LightlineFilename()
	return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

function! LspStatus()
	let sl = ''
	if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
		let sl.='E: '
		let sl.=luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])")
		let sl.=' W: '
		let sl.=luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")
      	endif
      	return sl
endfunction

let g:lightline = {
	\ 'active':{
	\ 	'left':[ ['mode', 'paste'],
	\ 	['gitbranch','readonly', 'filename', 'modified', 'lspStatus'] ],
	\
	\ 	'right':[ ['lineinfo'],
	\ 		['percent'],
	\ 		['fileencoding', 'filetype'] ]
	\ },
      	\ 'colorscheme': 'wombat', 
      	\ 'component_function': {
      	\   'filename': 'LightlineFilename',
	\   'gitbranch': 'gitbranch#name',
	\   'lspStatus': 'LspStatus'
      	\ },
\ }


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
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
set splitright
set splitbelow
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

" Permanent undo
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

" Python
let g:formatterpath = ['/usr/local/bin/autopep8']

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

let g:fzf_layout = { 'down': '~40%' }

" display whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.rs,*.cpp,*.h,*.js,*.ts  match BadWhitespace /\s\+$/

" JSON
au! BufRead,BufNewFile *.json set filetype=json
"autocmd FileType json autocmd BufWritePre <buffer> %!python -m json.tool

" *script
"autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
au BufNewFile,BufRead *.vue set tabstop=2 softtabstop=2 shiftwidth=2 textwidth=80 expandtab autoindent fileformat=unix 
au BufNewFile,BufRead *.html set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent fileformat=unix 

" Python
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent fileformat=unix 

" C/C++
map <C-K> :py3f /usr/share/clang/clang-format.py<cr>
imap <C-K> <c-o>:py3f /usr/share/clang/clang-format.py<cr>

autocmd FileType c,h,cpp setlocal equalprg=clang-format
function! Formatonsave()
  	let l:formatdiff = 1
	py3f /usr/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.c,*.cpp call Formatonsave()

" Copy into clipboard
xnoremap <silent> <leader>c :w !wl-copy <cr><cr>
noremap <leader>v :read !wl-paste --no-newline <cr><cr>

" Quick access files
map <C-p> :Files<CR>
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
