set nocompatible

" Set up Vundle if not installed {{{
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif
" }}}
filetype off
set rtp+=~/.vim/bundle/vundle/
"" Python3 Powerline (off -- doesn't work with neovim) {{{
" python3 from powerline.vim import setup as powerline_setup
" python3 powerline_setup()
" python3 del powerline_setup
"" }}}

" Vundle Plugins {{{
call vundle#rc()
" let Vundle manage Vundle
Plugin 'gmarik/vundle'
" ============================================================================
"" Better file browser
" Plugin 'scrooloose/nerdtree'
" Quickly anywhere without counting words
Plugin 'easymotion/vim-easymotion'
" Airline
Plugin 'bling/vim-airline'
" Class/module browser
Plugin 'majutsushi/tagbar'
" Zen coding
Plugin 'mattn/emmet-vim'
" Tab list panel
Plugin 'kien/tabman.vim'
" Terminal Vim with 256 colors colorscheme
Plugin 'fisadev/fisa-vim-colorscheme'
" Consoles as buffers
" Plugin 'rosenfeld/conque-term' -- not needed with neovim
" Surround
Plugin 'tpope/vim-surround'
" Expand region
Plugin 'terryma/vim-expand-region'
" Autoclose
Plugin 'Townk/vim-autoclose'
" Indent text object
Plugin 'michaeljsmith/vim-indent-object'
" Python mode (indentation, doc, refactor, lints, code checking, motion and
" operators, highlighting, run and ipdb breakpoints)
Plugin 'klen/python-mode'
" Better autocompletion
" Plugin 'Shougo/neocomplete.vim' -- doesn't work in neovim
" Window chooser
Plugin 't9md/vim-choosewin'
" Python and other languages code checker
Plugin 'scrooloose/syntastic'
" Search results counter
Plugin 'IndexedSearch'
" XML/HTML tags navigation
Plugin 'matchit.zip'
" Yank history navigation
Plugin 'YankRing.vim'
" Completion with TAB
Plugin 'ervandew/supertab'
" Jedi-Vim
Plugin 'davidhalter/jedi-vim'
" Restore vim sessions
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
" ============================================================================

" Install plugins the first time vim runs
if iCanHazVundle == 0
    echo "Installing Plugins, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
" ============================================================================
" }}}

" Vim Settings and Mappings {{{

" allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on

" tabs/spases {{{
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" tab length exceptions on some file types
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
" }}}

" always show status bar
set laststatus=2
set noshowmode

" incremental search
set incsearch
" highlighted search results
set hlsearch

" syntax highlight on
syntax on

" show line numbers
set number
set relativenumber
set autoindent smartindent

" tab navigation mappings
map tn :tabn<CR>
map tp :tabp<CR>
map tm :tabm<CR>
map tt :tabnew<CR>
map ts :tab split<CR>
map <C-S-Right> :tabn<CR>
imap <C-S-Right> <Esc>:tabn<CR>
map <C-S-Left> :tabp<CR>
imap <C-S-Left> <Esc>:tabp<CR>


" set completeopt-=preview

" save as sudo
 ca w!! w !sudo tee "%"
 
" " use 256 colors when possible
" if &term =~? 'mlterm\|xterm\|xterm-256\|screen-256'
" 	let &t_Co = 256
"     colorscheme torte
" else
"     colorscheme torte
" endif
" guifont
set guifont=Terminess\ Powerline\ 8
"set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 8
set guioptions-=T
set guioptions-=r
set guioptions-=i
set guioptions-=e
set guioptions-=L
set guioptions-=t
set guioptions-=m

" colors
set background=dark
colorscheme nwsome
set cursorline

" colors for gvim
if has('gui_running')
    colorscheme dw_orange
endif

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=7

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmenu
set wildmode=list:full

" better backup, swap and undos storage {{{
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo
" store yankring history file there too
let g:yankring_history_dir = '~/.vim/dirs/'

" create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif
" }}}

" indent without loosing focus
vnoremap < <gv
vnoremap > >gv

" command with colon
noremap ; :

"clear search results highlighting
nnoremap <C-L> :nohl<CR><C-L>

"highlight 79'th column
set tw=79 "width
set colorcolumn=79
highlight ColorColumn ctermbg=233

" map leader to space
let mapleader = " "

" open another split
map <F2> :sp<CR>
map <F4> :below 10sp term://$SHELL<CR>i
map <S-F14> :vs<CR>
map <S-F16> :vs<CR>:term<CR>
map <S-F16> :below 10sp term:///bin/ranger<CR>i

" close current split
map <F6> <Esc><C-w>c

" yank/paste to system clipboard {{{
nmap <F8> "+yy
vmap <F8> "+y
nmap <F9> "+p
vmap <F9> "+p
nmap <S-F21> "+P
vmap <S-F21> "+P
" }}}

" Ranger as the file-chooser {{{----------------------------------------------
function! RangeChooser()
    let temp = tempname()
    if has("gui_running")
        exec 'silent !urxvt -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <F3> :<C-U>RangerChooser<CR>
" }}}

" MS Windows Documents {{{----------------------------------------------------
" opening
" autocmd BufReadPre *.doc set ro
autocmd BufReadPre *.doc set hlsearch!
autocmd BufReadPost *.doc %!antiword "%"

" saving modified <NAME>.doc as <NAME>.txt
function! SaveCopyForMSWordDocs(filename) range
    let l:extension = '.' . fnamemodify( a:filename, ':e' )
    if l:extension == '.doc'
        let l:extension == '.txt'
    endif
    execute "write " . l:filename
endfunction
" }}}

" }}}

" Plugins Settings and Mappings {{{

" Tagbar {{{------------------------------------------------------------------
" toggle tagbar display
map <S-F13> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 0
" }}}

" EasyMotion {{{--------------------------------------------------------------
map <Leader> <Plug>(easymotion-prefix)

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward))
" }}}

" ExpandRegion {{{------------------------------------------------------------
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" }}}

" " ConqueTerm (off - not needed with neovim) {{{-----------------------------
" " disable terminal features, that make Conqu run slow
" let g:ConqueTerm_FastMode = 1
" " restore terminals when sestoring session
" let g:ConqueTerm_ExecFileKey = '<F5>'
" let g:ConqueTerm_SessionSupport = 1
" let g:ConqueTerm_PyVersion = 3
" map <F4> :ConqueTermSplit zsh<CR>
" " }}}

" NERDTree (off) {{{----------------------------------------------------------
"  " toggle nerdtree display
" map <F3> :NERDTreeToggle<CR>
"  " open nerdtree with the current file selected
" nmap ,t :NERDTreeFind<CR>
"  " don;t show these file types
" let NERDTreeIgnore = ['\.pyc$', '\.pyo$']
" }}}

" Syntastic {{{---------------------------------------------------------------
" show list of errors and warnings on the current {{{e
nmap ,e :Errors<CR>
" check also when just opened the file
let g:syntastic_check_on_open = 1
" don't put icons on the sign column (it hides the vcs status icons of signify)
let g:syntastic_enable_signs = 1
" custom icons (enable them if you use a patched font, and enable the previous
" setting)
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'
" }}}

" Python-mode {{{-------------------------------------------------------------
let g:pymode_doc = 0
let g:pymode_doc_key = 'K'
let pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_virtualenv = 1
nmap ,D :tab split<CR>:PymodePython rope.goto()<CR>
nmap ,o :RopeFindOccurrences<CR>
" }}}

" TabMan {{{------------------------------------------------------------------
" mappings to toggle display, and to focus on it
let g:tabman_toggle = 'tl'
let g:tabman_focus  = 'tf'
" }}}

" Autoclose {{{---------------------------------------------------------------
" fix to let ESC work as espected with Autoclose plugin
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}
" }}}

" Window Chooser {{{----------------------------------------------------------
nmap  -  <Plug>(choosewin)
" show big letters
let g:choosewin_overlay_enable = 1
" }}}

" Neocomplete {{{-------------------------------------------------------------
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=python3complete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
" }}}

" }}}

" Airline {{{-----------------------------------------------------------------
let g:airline_powerline_fonts=1
let g:airline_theme='simple'

" tab line
let g:airline#extensions#tabline#enabled=0

" Neovim Settings {{==========================================================
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"}}===========================================================================


" vim:foldmethod=marker:foldlevel=0
