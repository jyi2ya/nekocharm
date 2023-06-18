" ==== personal ====
let g:coc_status_warning_sign = '!!'

" set signcolumn=yes

set background=light
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme

if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" === end ===

" leader
" let mapleader = ','
" let g:mapleader = ','

set nocompatible                " don't bother with vi compatibility

" filetype
filetype on
" Enable filetype plugins
filetype plugin on
filetype indent on
" syntax
syntax on
set synmaxcol=500

" history : how many lines of history VIM has to remember
set history=2000

" files and directories
set swapfile
set undofile

if has('nvim')
    set undodir=~/.local/share/nvim/undo//
    set directory=~/.local/share/nvim/swap//
else
    set undodir=~/.local/share/vim/undo//
    set directory=~/.local/share/vim/swap//
endif

" base
set viminfo='200,<5000,s4096,:5000
set autoread                    " reload files when changed on disk, i.e. via `git checkout`
set shortmess=atI

set magic                       " For regular expressions turn magic on
set title                       " change the terminal's title
set nobackup                    " do not keep a backup file

set novisualbell                " turn off visual bell
set noerrorbells                " don't beep
set visualbell t_vb=            " turn off error beep/flash
set t_vb=
set tm=500

" show location
" set cursorcolumn
set cursorline

" movement
set scrolloff=3                 " keep 3 lines when scrolling

" show
set ruler                       " show the current row and column
set relativenumber
set nowrap
set showcmd                     " display incomplete commands
set showmode                    " display current modes
set showmatch                   " jump to matches when entering parentheses
set matchtime=2                 " tenths of a second to show the matching parenthesis

" search
" set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present
" augroup vimrc-incsearch-highlight
" 	autocmd!
" 	autocmd CmdlineEnter /,\? :set hlsearch
" 	autocmd CmdlineLeave /,\? :set nohlsearch
" augroup END

" tab
set expandtab                   " expand tabs to spaces
set smarttab
set shiftround

" indent
set autoindent smartindent shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab

" NOT SUPPORT
" fold
" set foldenable
" set foldmethod=marker
" set foldlevel=99
let g:FoldMethod = 0
map <leader>zz :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun

" encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8
set ffs=unix,dos,mac
set formatoptions+=m
set formatoptions+=B
"set ambiwidth=double

" select & complete
set selection=inclusive
set selectmode=mouse,key

set completeopt=longest,menu
set wildmenu                           " show a navigable menu for tab completion"
set wildmode=longest,list,full
set wildignore=*.o,*~,*.pyc,*.class

" others
set backspace=indent,eol,start  " make that backspace key work the way it should
set whichwrap=<,>,b,s
set noequalalways

" if this not work ,make sure .viminfo is writable for you
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Enable basic mouse behavior such as resizing buffers.
set mousehide
" set mouse=a

" ============================ theme and status line ============================

" theme
set colorcolumn=78
highlight ColorColumn ctermbg=grey guibg=grey
highlight SignColumn ctermbg=grey guibg=grey

" set mark column color
"hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" status line
" set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set laststatus=0   " Always show the status line - use 2 lines for the status bar

" ============================ specific file type ===========================

" autocmd Filetype text RainbowToggleOff
autocmd Filetype text set cc=
autocmd Filetype text set wrap
autocmd Filetype markdown.mkd set cc=
autocmd Filetype markdown.mkd set wrap

autocmd Filetype go inoremap ?? if err != nil {<CR>return err<CR>}<CR>
autocmd Filetype go inoremap ??? if err != nil {<CR>return nil, err<CR>}<CR>

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
autocmd BufRead,BufNew *.md,*.mkd,*.markdown  set filetype=markdown.mkd

autocmd BufNewFile *.sh,*.pl exec ":call AutoSetFileHead()"

function! AutoSetFileHead()
    " .sh
    if &filetype == 'sh'
        call append(0, '#!/bin/sh')
        call append(1, 'set -eu')
        call append(2, 'IFS=$(printf "\n\t")')
        call append(3, '# scratch=$(mktemp -d -t tmp.XXXXXXXXXX)')
        call append(4, '# atexit() {')
        call append(5, '#   rm -rf "$scratch"')
        call append(6, '# }')
        call append(7, '# trap atexit EXIT')
    endif

    " perl
    if &filetype == 'perl'
        call append(0, '#!/usr/bin/env perl')
        call append(1, "use v5.20;")
        call append(2, "use utf8;")
        call append(3, "use warnings;")
        call append(4, "use feature 'signatures';")
        call append(5, "use open qw(:std :utf8);")
    endif

    normal G
    normal o
endfunc

autocmd FileType markdown.mkd,rust,c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" ============================ key map ============================

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nnoremap <F2> :set nu! nu?<CR>
nnoremap <F3> :set list! list?<CR>
nnoremap <F4> :set wrap! wrap?<CR>
set pastetoggle=<F5>            "    when in insert mode, press <F5> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented
au InsertLeave * set nopaste
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

" tab 替换 Esc
inoremap <Tab> <Esc>

" Quickly close the current window
nnoremap <leader>q :q<CR>
" Quickly save the current file
nnoremap <leader>w :w<CR>

" select all
map <Leader>sa ggVG"

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" switch # *
" nnoremap # *
" nnoremap * #

"Keep search pattern at the center of the screen."
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" remove highlight
noremap <silent><leader>/ :nohls<CR>

"Reselect visual block after indent/outdent.调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv

" y$ -> Y Make Y behave like other capitals
map Y y$

"Map ; to : and save a million keystrokes
" ex mode commands made easy 用于快速进入命令行
" nnoremap ; :

" Shift+H goto head of the line, Shift+L goto end of the line
" nnoremap H ^
" nnoremap L $

" save
" cmap w!! w !sudo tee >/dev/null %

" command mode, ctrl-a to head， ctrl-e to tail
cnoremap <C-A>		<Home>
cnoremap <C-B>		<Left>
cnoremap <C-D>		<Del>
cnoremap <C-E>		<End>
cnoremap <C-F>		<Right>
cnoremap <C-N>		<Down>
cnoremap <C-P>		<Up>
cnoremap <Esc><C-B>	<S-Left>
cnoremap <Esc><C-F>	<S-Right>

" enable ERE
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %smagic/
cnoremap >s/ >smagic/ 
nnoremap :g/ :g/\v
nnoremap :g// :g//

" plugin settings
let g:is_sh = 0
let g:rustfmt_autosave = 1
let g:rainbow_active = 1

" file is large from 4mb
let g:LargeFile = 1024 * 1024 * 4

augroup LargeFile 
    au!
    autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function! LargeFile()
    " no syntax highlighting etc
    set eventignore+=FileType
    " save memory when other file is viewed
    setlocal bufhidden=unload
    " is read-only (write with :w new_filename)
    setlocal buftype=nowrite
    " no undo possible
    setlocal undolevels=-1

    setlocal noswapfile
       " display message
    autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

" 设置netrw-------------------------------------
let g:netrw_banner = 0         " 设置是否显示横幅
let g:netrw_liststyle = 3      " 设置目录列表样式：树形
let g:netrw_browse_split = 4   " 在之前的窗口编辑文件
let g:netrw_altv = 1           " 水平分割时，文件浏览器始终显示在左边
let g:netrw_winsize = 80       " 设置文件浏览器窗口宽度为25%
let g:netrw_list_hide= '^\..*' " 不显示隐藏文件 用 a 键就可以显示所有文件、 隐藏匹配文件或只显示匹配文件

" 自动打开文件浏览器
" augroup ProjectDrawer
"     autocmd!
"     autocmd VimEnter * :Vexplore
" augroup END

nnoremap <SPACE>f :Lexplore<CR>    " 打开或关闭目录树
hi CocInlayHint ctermfg=Grey
