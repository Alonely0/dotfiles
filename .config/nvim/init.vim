"automated installation of vimplug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if (has('termguicolors'))
  set termguicolors
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

syntax on " highlight syntax
colorscheme dracula
highlight Normal guibg=NONE ctermbg=NONE
set rnu " show line numbers
set hlsearch " highlight all results
set ignorecase " ignore case in search
set incsearch " show search results as you type
set showcmd

let mapleader = ","
map <leader>gs :CocSearch
map <leader>fs :Files<CR>
map <leader>h  :noh<CR>
map <leader>q  :wqa<CR>
map <leader>h <C-w>h
map <leader>j <C-w>j
map <leader>k <C-w>k
map <leader>l <C-w>l
map <leader>hh :call WinMove('h')<CR>
map <leader>jj :call WinMove('j')<CR>
map <leader>kk :call WinMove('k')<CR>
map <leader>ll :call WinMove('l')<CR>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <silent><expr> <C-space> coc#refresh()

"GoTo code navigation
nmap <leader> g <C-o>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

"show all diagnostics.
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
"manage extensions.
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>

map ; :Files<CR>

"example defaults for new projects
set expandtab
set tabstop=2
set shiftwidth=2

autocmd TextChanged,TextChangedI <buffer> silent write

function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

nnoremap <C-Z> u
nnoremap <C-X> <C-R>
nnoremap <silent> <C-B> :NERDTreeToggle<CR>
let g:user_emmet_expandabbr_key = '<C-a>,'
let g:ranger_map_keys = 0
nnoremap <silent> <C-c><C-R> :Ranger<CR>
augroup nerdtree_open
    autocmd!
    autocmd VimEnter * NERDTree | wincmd p
augroup END
nnoremap <C-Tab> :tabNext
lua << END
local fn = vim.fn
local o = vim.o
local cmd = vim.cmd

local function highlight(group, fg, bg)
    cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

highlight("StatusLeft", "#ff79c6", "#00000000")
highlight("StatusMid", "#50fa7b", "#00000000")
highlight("StatusRight", "#8be9fd", "#00000000")

local function get_column_number()
    return fn.col(".")
end

function status_line()
    return table.concat {
        "%#StatusLeft#",
        "%f",
        "%=",
        "%#StatusMid#",
        "%l,",
        get_column_number(),
        "%=",
        "%#StatusRight#",
        "%p%%"
    }
end

vim.o.statusline = "%!luaeval('status_line()')"
