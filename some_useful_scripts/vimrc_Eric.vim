" VIM configure script
" For Linux/Mac user: save this file as '~/.vimrc'
" For Windows user: save this file as '~\_vimrc', where '~' is your home director
" Author: Eric
" Date: Oct 08, 2015

set nocompatible
set dir=$HOME/.vim/.swapfiles//
syntax enable
filetype on
filetype plugin on
"filetype indent on
"expand tab to 4 space(tabstop); use :retab to expand all tab in a file
"set expandtab
set tabstop=4 shiftwidth=4 
set backspace=2
set backspace=indent,eol,start
set ruler
set number
"set relativenumber
set scrolloff=5 "minimum number of screen lines above and below the cursor
"set wrap  
set cindent
set autoindent
"set smartindent
set cinoptions=>s,e0,n0,f0,{0,}1s,^0,L-1,:s,=s,l0,b1,gs,hs,ps,ts,is,+s,c3,C0,/0,(s,u1s,U1s,w1,W1,m0,j1,J1,)20,*70,#0
" set cinkeys=0),0},:,1#
"set cinkeys=0{,0}
"
set hidden "hind the file to buffer but open, when open a new file. 
set wildmenu "in command mode, list result when <Tab>
set wildmode=list:longest,full
set ttyfast
"
" the following set turns on unlimited undo, even if after files are closed
" set undofile
" set undodir=$HOME/.vim/.undofiles//
"
" the following set the directory for swap file, '//' means using full path as
" file name
" set dir = dir=$HOME/.vim/.swapfiles//
"
set gdefault "replace globally as default
"set shiftround
color desert
"source ~/Dropbox/Huihui/Computer_notes/My_VIM_Notes/vim/colors/molokai.vim

set bg=dark
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
"set hlsearch "highlight search results
set mouse=a
set mousemodel=popup
"set clipboard=unnamedplus
"set t_Co=256
"set spell
set listchars=tab:\|\ 
set list


let maplocalleader = ","
"let mapleader = ";"

au BufNewFile,BufRead *.Rnw set filetype=tex
au BufNewFile,BufRead *.tex set filetype=tex
au BufNewFile,BufRead *.py set filetype=python
au BufNewFile,BufRead *.pl set filetype=perl
au BufNewFile,BufRead *.r,*.R set filetype=R
au BufNewFile,BufRead *.r,*.R set filetype=r
au BufNewFile,BufRead *.sas set filetype=SAS
au BufNewFile,BufRead *.md set filetype=markdown
"au BufNewFile,BufRead *.md set filetype=markdown
"au BufNewFile,BufRead *.markdown set filetype=markdown

autocmd! filetype R,r map <localleader>sd <localleader>ss<Esc>
autocmd! filetype tex nmap <localleader>[ mz%i\right<Esc>`zi\left<Esc>l
autocmd! filetype tex nmap <localleader>] mz%i\right<Esc>`zi\left<Esc>l%
autocmd! filetype cpp set makeprg=g++
autocmd! filetype map <localleader>l :!./a.out<CR><CR>
autocmd! filetype map <localleader>c :make %<CR>

"-------------------------------
"latex-suite, platform dependent
"-------------------------------
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_CompileRule_pdf = 'pdflatex --synctex=-1 -src-specials -interaction=nonstopmode -file-line-error-style $*'
let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_MultipleCompileFormats='pdf'
"
"

" Rainbow Parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" ===================
" Platform/OS setting
"
" ===================
if has('win64') || has('win32')
    "Re-direct backup location
    set backupdir=~\temp\Vim_backup
    set directory=~\temp\Vim_backup
    set undodir=~\temp\vim_undofile

    "fast access to  vimrc
    map <leader>vv <Esc>:tabe ~/_vimrc<CR>
    map <leader>ss <Esc>:so ~/_vimrc<CR>
    "set up pdf viewer for LaTex
    let g:Tex_ViewRule_pdf = 'C:\Program Files (x86)\SumatraPDF\SumatraPDF.exe'
else " for Unix-like system
    "
    " au FocusLost * :wa "auto save when vim lose focus
    "fast access to .vimrc
    map <leader>vv <Esc>:tabe ~/.vimrc<CR>
    map <leader>ss <Esc>:so ~/.vimrc<CR>
    "
    " ------------------------------------------------
    if has('mac')  " particularly for mac
        let g:Tex_ViewRule_ps = 'open -a Preview'
        let g:Tex_ViewRule_pdf = 'open -a Preview'
        "interact with R console within tmux or screen
        "source ~/.vim/R.vim
        "map <LocalLeader>r <F3>
        "map <LocalLeader>l <F3>
        "imap <LocalLeader>l <F3>
        "au BufNewFile,BufRead *.r,*.R inoremap  __ _
        "au BufNewFile,BufRead *.r,*.R inoremap  _ <Space><-<Space>

        "map <LocalLeader>sl <F3>

    endif
    " ------------------------------------------------
endif

"____________________
" GUI setting
"____________________
if has("gui_running")
    colorscheme molokai
    "set cursorline
	if has("gui_gtk2")
		set guifont=Inconsolata\ 11
	elseif has("gui_macvim")
		set gfn=Monaco:h12
	elseif has("gui_win32")
		set guioptions-=T
		set guifont=Consolas:h11:cANSI
        "require vimtweak.dll for to transparent style in gvim
		let g:transparentOn = 2
		function MakeTransparent()
			if g:transparentOn < 3
				call libcallnr("vimtweak.dll", "SetAlpha", 225 + g:transparentOn * 10 )
				let g:transparentOn += 1
			else 
				call libcallnr("vimtweak.dll", "SetAlpha", 255)
				let g:transparentOn = 0
			endif
		endfunction
		nmap <F11> :call MakeTransparent()<CR>
	endif
endif

"------------------------------------
" Vim-R-plugin
"------------------------------------
let vimrplugin_objbr_place = "console,right"
if $DISPLAY != ""
    let vimrplugin_openpdf = 1
    let vimrplugin_openhtml = 1
endif
if has("gui_running")
    inoremap <C-Space> <C-x><C-o>
else
    inoremap <Nul> <C-x><C-o>
endif
"let vimrplugin_screenvsplit = 1

if has('mac') 
    let vimrplugin_tmux = 0
else
    let g:ScreenImpl = 'Tmux'
endif

vmap <C-Space> <Plug>RDSendSelection
nmap <C-Space> <Plug>RDSendLine
"<Leader>rf to start
"map <F2> <Plug>RStart 
"imap <F2> <Plug>RStart
"vmap <F2> <Plug>RStart


"----------------------------
" My Keyboard mapping 
"----------------------------
imap jj <Esc> 
"nnoremap j gj
"nnoremap k gk
map <C-l> :tabn<CR>
map <C-m> :tabn<CR>
map <C-j> :bn<CR>
map <C-k> :bp<CR>
map <C-h> :tabp<CR>
map <C-n> :tabp<CR>
map <C-s> <Esc>:w<CR>
imap <C-s> <Esc>:w<CR>
"map <C-S-h> <C-w><Left>
"map <C-S-j> <C-w><Down>
"map <C-S-k> <C-w><Up>
"map <C-S-l> <C-w><Right>
nmap <F2> :NERDTree<CR>
nmap <LocalLeader>s <C-c><C-c>
vmap <LocalLeader>s <C-c><C-c>

vmap <LocalLeader>t= :Tab/=<CR>
vmap <LocalLeader>t: :Tab/:<CR>
vmap <LocalLeader>t_ :Tab/<-<CR>

map <Leader>[ :set paste<CR>
map <Leader>] :set nopaste<CR>

"-----
" SAS
"-----
autocmd! filetype SAS map <localleader>r <Esc>:w<CR>:!sas %<CR><CR>:botright sp +set\ noma %:r.log<CR>G:tabe +set\ noma %:r.lst<CR>:tabp<CR>
"autocmd! filetype SAS map <localleader>rt <Esc>:w<CR>:!sas %<CR><CR>:tabe +set\ noma %:r.log<CR>:tabe +set\ noma %:r.lst<CR>:tabp<CR>
"autocmd! filetype SAS map <localleader>rs <Esc>:w<CR>:!sas %<CR><CR>:botright vsp +set\ noma %:r.lst<CR>G:sp +set\ noma %:r.log<CR>

""----------------
"" Tricks
""----------------
"" insert paste mode
" :set paste
" :set nopaste
"
" --------
"  C, C++
" --------
au filetype c,cpp nnoremap <LocalLeader>l <Esc>:w <bar> make % <bar> !./a.out <CR>
au filetype c,cpp nnoremap <LocalLeader>c <Esc>:w <bar> make %<CR>
au filetype c,cpp nnoremap <LocalLeader>e <Esc>:!./a.out<CR>
