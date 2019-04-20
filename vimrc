" ------------------------------------------------
" Randy Yumul's vimrc
" ------------------------------------------------

filetype off

" must do this before any other mappings
let mapleader = "\<Space>"

" map <CR> to : but not for quickfix or command windows!!!
" thanks to /u/meribold in this post: https://www.reddit.com/r/vim/comments/4m678o/best_way_to_remap_cr_in_normal_mode/
nnoremap <expr> <CR> empty(&buftype) \|\| &bt ==# 'help' \|\| &ft ==# 'man' ?  ':' : '<CR>'
vnoremap <expr> <CR> empty(&buftype) \|\| &bt ==# 'help' \|\| &ft ==# 'man' ?  ':' : '<CR>'

nnoremap <Leader>h :noh<CR>
xnoremap <Leader>h :<C-U>noh<CR><ESC>gv

" reset all autocmds
autocmd!

" auto reading/writing  {{{1
set autoread                             " auto read externally modified files
set autochdir                            " automatically cd to dir of file in current buffer

set sessionoptions-=options

autocmd BufReadPost * call util#UpdateModifiable()

" UI {{{1
set backspace=eol,start,indent           " make backspace better
set belloff=all                          " disallow annoying bell sound
set cmdheight=2                          " number of lines to use for the command-line
if findfile("~/config/spell/en.utf-8.add") != ""
    set dictionary+=~/config/spell/en.utf-8.add
    set spellfile=~/config/spell/en.utf-8.add
endif
set hidden                               " deal with multiple buffers better
set history=1000                         " remember more than 20 commands
set linebreak                            " break at a word boundary
set number                               " Turn on line numbering
if version >= 800
	set relativenumber                   " Turn on relative line numbering
	set number                           " Turn on absolute line numbering
endif
set shortmess=imt                        " clean up the 'Press ENTER ...' prompts
set splitright                           " new window is put right of the current one
set title                                " set terminal title
set titlestring=%f%m%y                   " filename, modified, filetype
set undofile                             " automatically save undo history to an undo file when writing a buffer to a file
if isdirectory($HOME . '/temp/vimundo') == 0
    silent !mkdir -p ~/temp/vimundo > /dev/null 2>&1
endif
set undodir=~/temp/vimundo
set undolevels=200
set ttimeoutlen=0                        " time in milliseconds that is waited for a key code or mapped key
set wildmenu                             " enhanced file/command tab completion
set wildmode=list:longest,full           " set file/command completion mode
										 " list:longest      When more than one match, list all matches and
										 "                    complete till longest common string.
										 "
										 " full"              Complete the next full match.  After the last match,
										 "                    the original string is used and then the first match
										 "                    again.
set wildcharm=<C-Z>
set nowrap                               " default to display no line wrapping
set fillchars=""                         " get rid of the characters in window separators
set diffopt+=vertical                    " start 'diffthis' vertically by default
set showtabline=1
if has("gui")
	set guioptions-=T                    " remove toolbar
	set guioptions-=m                    " remove drop down menu
	set guioptions+=b                    " allow horizontal scrollbar
	set guioptions+=l                    " left scrollbar always 'L' is for when split
	set guioptions-=g                    " grey menu items that aren't active
	" set guioptions-=e                    " gui tabs
endif

set laststatus=2                         " always a status line
set statusline=\ %F                      " Full path to the file in the buffer.
set statusline+=[%{&ff}]                 " file format
set statusline+=%m                       " modified flag
set statusline+=%r                       " readonly flag
set statusline+=%y                       " type of file in the buffer
set statusline+=%=                       " separation point between left and right aligned items
set statusline+=%c                       " column number
set statusline+=,%l                      " line number
set statusline+=/%p%%                    " percentage through file

set noswapfile                           " I almost never look at these anyway
set showcmd                              " show how much is selected in visual mode
set virtualedit+=block                   " allow virtual editing in visual mode

packadd! matchit                         " extend % matching (on osx, better to copy plugin into .vim directory)

" set background coloring and other specific things
if findfile("~/.vimrc.local") != ""
	source ~/.vimrc.local
endif

" remove all menus in all modes
" aunmenu *
" right click context menu to jump back
if has("gui")
    noremenu <silent> 1.04 PopUp.Push\ Tag<Tab><C-]> <C-]>
    noremenu <silent> 1.05 PopUp.Back<Tab><C-O> <C-O>
    noremenu <silent> 1.06 PopUp.Forward<Tab><C-I> <C-I>
    noremenu <silent> 1.07 PopUp.Top<Tab>gg gg
    noremenu <silent> 1.0701 PopUp.Close\ Window :wincmd c<CR>
    noremenu <silent> 1.0702 PopUp.Close! :bd!<CR>
    an 1.08 PopUp.-SEP0-			<Nop>
    menu <silent> 1.09 PopUp.Find<Tab>/<C-R>+ /<C-R>+<CR>
    an 1.095 PopUp.-SEP0-5-			<Nop>
endif

set cmdwinheight=11   " show last 10 items in cmdwin history

" indentation {{{1
set autoindent                           " autoindent
set shiftwidth=4                         " tab size
set tabstop=4                            " tab size
set listchars=eol:\$,tab:>.,trail:.,extends:\

" searching {{{2
set hlsearch                             " highlight matched text
set incsearch                            " incremental search
set nowrapscan

" syntax highlighting                    {{{1
syntax on                                " enable syntax highlighting
filetype on                              " enable filetype detection
filetype indent on                       " enable filetype-specific indenting
filetype plugin on                       " enable filetype-specific plugins

" change cursor shape depending on mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

if exists('$TMUX')
	let &t_SI = "\ePtmux;\e\e[5 q\e\\"
	let &t_SR = "\ePtmux;\e\e[4 q\e\\"
	let &t_EI = "\ePtmux;\e\e[2 q\e\\"
endif


" MODE MAPPINGS {{{1

" TIP: way to check if mapping is already taken:
" :echo mapcheck(';g', 'n')   " first arg is keymap, second is mode
" also can us hasmapto() for reverse lookup

nnoremap Y y$

" windows-esque mappings {{{2
nnoremap <C-C> "+yy
vnoremap <C-C> "+y
inoremap <C-B> <Esc>"+pa

" replace text without killing the yank register
xnoremap <Leader>p "_dP

" better way to press escape: {{{2
inoremap jj <Esc>:wall<CR>
inoremap kk <Esc>:wall<CR>
inoremap kj <Esc>:wall<CR>
inoremap jk <Esc>:wall<CR>
cnoremap kj <Esc>
cnoremap jk <Esc>
cnoremap jj <Esc>
cnoremap kk <Esc>

" quick save {{{2
nnoremap S :wa<CR>

" navigate wrapped lines easier
nnoremap gj j
nnoremap gk k
nnoremap j gj
nnoremap k gk

xnoremap gj j
xnoremap gk k
xnoremap j gj
xnoremap k gk

" easier way to alternate between 2 files {{{2
nnoremap <Leader>a :b#<CR>
nnoremap <BS> :b#<CR>

" quick way to add a new search to current search {{{2
nnoremap \| /<C-R><C-W>\\|<C-R>/<CR>
xnoremap \| y/<C-R>0\\|<C-R>/<CR>

" navigate through occurrences of previous search w/in current file
nnoremap g/ :g/<C-R><C-W>/#<CR>:normal! ``<CR>:
nnoremap <Leader>g/ :g//#<Left><Left>
vnoremap g/ y:g/<C-R>0/#<CR>:normal! ``<CR>:

" search within a highlighted selection  {{{2
xnoremap <Leader>/v <Esc>/\%V

" search w/ ignorecase off/on
nnoremap <Leader>/C /\C
nnoremap <Leader>/c /\c

" better way to execute macros (assuming macro was recorded to register 'q') {{{2
nnoremap Q @q

" paste from search register better {{{2
inoremap <C-R>/ <C-O>:call formatting#StripSearchRegister()<CR><C-R>/

" paste from registers easier (note the trailing space) {{{2
nnoremap <Leader>p :display<CR>:put 

" modify registers easier, type crq to edit register 'q'
function! ChangeReg() abort
  let x = nr2char(getchar())
  call feedkeys("q:ilet @" . x . " = \<c-r>\<c-r>=string(@" . x . ")\<cr>\<esc>0f'", 'n')
endfunction
nnoremap cr :call ChangeReg()<cr>

" better undo
inoremap <C-W> <C-G>u<C-W>

" complete options
"   . = current buffer
"   w = windows
"   b = buffers
"   u = unloaded buffers
"   t = tag completion
set complete=.,b,w,u,t

" easy line completion {{{2
inoremap <C-L> <C-X><C-L>

" better navigating through buffers {{{2
nnoremap <Leader>b :ls<CR>:b

" edit current file in a new tab {{{2
nnoremap <silent> <Leader>te <C-W>T

" easy to move to next/prev tab {{{2
nnoremap t gt
nnoremap T gT

" easy open new tab {{{2
nnoremap <silent> go :tabnew<CR>
" do it this way so edited files can still be opened in a new tab {{{2
nnoremap <silent> <Leader>go :tabnew<CR>:edit #<CR>

" better navigating back thru files {{{2
nnoremap <Leader><C-O> :jumps<CR>:normal <C-O><Left>

" navigating back thru changes {{{2
nnoremap <Leader><C-G> :changes<CR>:normal g;<Left><Left>

" close a buffer {{{2
nnoremap <Leader>Q :bd!<CR>
nnoremap <Leader>q :bd<CR>

" 'e'dit 'v'imrc, and source 'v'imrc, respectively) {{{2
nnoremap <silent> <Leader>ev :edit ~/config/vimfiles/vimrc<CR>
nnoremap <silent> <Leader>sv :source ~/config/vimfiles/vimrc<CR>:echomsg "sourced vimrc"<CR>:sleep 1<CR>:echomsg ""<CR>

" yank filename to clipboard {{{2
nnoremap <Leader>y% :let @+=expand('%')<CR>:let @"=expand('%')<CR>
nnoremap <Leader>Y% :let @+=expand('%:p')<CR>:let @"=expand('%:p')<CR>

" visually search for highlighted text
xnoremap * y/<C-R>0<CR>
xnoremap # y?<C-R>0<CR>

" easily select previous changed or yanked text {{{2
nnoremap gV '[V']

" easy window switching {{{2
nnoremap <silent> <C-H> <C-W>h
nnoremap <silent> <C-J> <C-W>j
nnoremap <silent> <C-K> <C-W>k
nnoremap <silent> <C-L> <C-W>l

" easy window resizing {{{2
nnoremap <Up> <C-W>+
nnoremap <Down> <C-W>-
nnoremap <Left> <C-W><
nnoremap <Right> <C-W>>

" put current line at top of window -15 lines (NOTE: overrides 'zg', which {{{2
" added a misspelled word to the dictionary)
nnoremap zg zt15<C-Y>

" quicker to correct spelling
nnoremap z- 1z=

" nice way of opening/closing quickfix window {{{2
nnoremap <silent> cv :call toggles#QuickFixToggle()<CR>

" lookup word under cursor in vim help
autocmd FileType vim nnoremap <buffer> K yiw:help <C-R>"<CR>

" Return to last edit position when opening files (You want this!) '\" is the cursor position when last exiting the current buffer {{{2
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" these should probably go in vimfiles/ftplugin/*.vim but am leaving them here for now 
autocmd BufNewFile,BufRead *.ion set filetype=javascript expandtab noautochdir
augroup PerlMason
	autocmd!
	autocmd BufNewFile,BufRead *.pm set filetype=perl expandtab
	autocmd BufNewFile,BufRead *.mi set filetype=mason expandtab
	autocmd BufNewFile,BufRead *.mi set commentstring=#\ %s
	autocmd BufNewFile,BufRead *.mi noremap <buffer> [m ?<%\(def\\|method\) \zs\S*\ze><CR>
	autocmd BufNewFile,BufRead *.mi noremap <buffer> ]m /<%\(def\\|method\) \zs\S*\ze><CR>
	autocmd BufNewFile,BufRead *.mi nnoremap <buffer> <Leader>gm :g/<%\(def\\|method\) \zs\S*\ze>/#<CR>:normal! ``<CR>:
	autocmd BufNewFile,BufRead *.pm noremap <buffer> [m ?^sub<CR>
	autocmd BufNewFile,BufRead *.pm noremap <buffer> ]m /^sub<CR>
	autocmd BufNewFile,BufRead *.mi nnoremap <buffer> <C-]> yiw:keepjumps normal gg<CR>:let tmpsearch=@/<CR>/<%\(def\\|method\) .*<C-R>0<CR>:let @/=tmpsearch<CR>
	autocmd BufNewFile,BufRead *.mi,*.pm set iskeyword-=:
	autocmd BufNewFile,BufRead Config set expandtab
	autocmd BufNewFile,BufRead build.xml set expandtab
augroup END

" Using BufLeave with this autocmd disallows the use of ToggleDiffOrig() {{{2
if version == 800
	augroup RMYGroup
		autocmd!
		autocmd RMYGroup InsertEnter * set norelativenumber
		autocmd RMYGroup InsertLeave * set relativenumber
		autocmd RMYGroup WinLeave * set norelativenumber
		autocmd RMYGroup WinEnter * set relativenumber
	augroup END
endif

" CUSTOM COMMANDS {{{2

" easy date/time insertion
command! Date :normal a<C-R>=strftime("\%Y-\%m-\%d")<CR>
command! Time :normal a<C-R>=strftime("\%H:\%M:\%S")<CR>
inoremap <C-R><C-D> <C-O>:Date<CR><Right>
inoremap <C-R><C-T> <C-O>:Time<CR><Right>

" quickly make a scratch buffer
command! Scratch set buftype=nofile
command! SC set buftype=nofile

" toggle prose settings
command! Prose call toggles#ProseToggle()

" delete all but this buffer (must save first) 'Buffer Only'
command! BOnly call util#BufOnly()

" easily switch to corresponding test file in java
autocmd BufNewFile,BufRead *.java command! Test call TestToggle()

function! TestToggle()
    let filename=@%
    Gcd
    if filename =~# '.*Test.java'
        let canonicalfile=expand('%:t:r')[:-(strlen('Test')+1)] . '.java'
        execute "find " . canonicalfile
    else
        execute "find " . expand('%:t:r') . "Test.java"
    endif
endfunction

" more text objects, courtesy of romainl: {{{2
" https://www.reddit.com/r/vim/comments/4d6q0s/weekly_vim_tips_and_tricks_thread_4/
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '`' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" Experimental: go back and forth in undo tree using CTRL-ScrollWheel
nnoremap <C-ScrollWheelDown> g-
nnoremap <C-ScrollWheelUp> g+

" Abbreviations {{{1
cnoremap %% <C-r>=expand('%:p')<CR>

" misspellings
iabbrev puase pause
iabbrev Puase Pause
iabbrev teh the
iabbrev Teh The
iabbrev treu true
iabbrev lenght length
iabbrev Lenght Length
iabbrev transfrom transform

" make it easier to do redir
cabbrev redir redir @a> "redire for redir END
cabbrev redire redir END

" folding settings {{{1
set foldmethod=indent
set foldlevel=99
nnoremap yof :call toggles#ToggleFoldMethod()<CR>

" difforig {{{1
if !exists(":DiffOrig")
  command! DiffOrig leftabove vert new | set bt=nofile | r # | 0d | windo diffthis
endif

" 'd'iff 'o'rig, and use 'd'iff key 'm'apping
nnoremap <Leader>do :call formatting#ToggleDiffOrig()<CR>
nnoremap <Leader>dh :call Diff1HourAgo( '1h' )<CR>

" Ag {{{1
" The Silver Searcher
if executable('rg')
    " Use rg over grep
    let g:ackprg = "rg --vimgrep --no-heading"
    cnoreabbrev ag Ack
elseif executable('ag')
    " Use ag over grep
    let g:ackprg = "ag --vimgrep"
    cnoreabbrev ag Ack
    set shellpipe=&>
endif

"search current file for current word
nnoremap <F10> :Ack <C-R><C-W> %<CR>
nnoremap <S-F10> :Ack  %<Left><Left>
let g:ack_apply_qmappings = 0

" ClosePair {{{1
inoremap ( ()<ESC>i
inoremap ) <c-r>=formatting#ClosePair(')')<CR>
inoremap { {}<ESC>i
inoremap } <c-r>=formatting#ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=formatting#ClosePair(']')<CR>
inoremap [[ [[
inoremap {{{ {{{

" Color switching {{{1
nnoremap <F3> :call NextColor(1)<CR>
nnoremap <F2> :call NextColor(-1)<CR>

" Commentary {{{1
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
autocmd FileType cfg setlocal commentstring=#\ %s
nmap gh gc
nmap ghg gcc
nmap ghh gcc
vmap gh gc

" fzf {{{1
nnoremap <C-_> :Gcd<CR>:Files<CR>
nnoremap <C-P> :History<CR>
nnoremap <C-N> :Files<CR>
nnoremap <Leader>l :Lines<CR>

" EasyAlign {{{1
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga :EasyAlign //<Left>

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" <C-/> to get into regular expression mode
nmap ga <Plug>(EasyAlign)

" Fugitive {{{1
nnoremap <F5> :Gstatus<CR>

" search from the top level .git directory for word under the cursor
" (chose F7 because CMD+F7 is show variable usage w/in IntelliJ)
nnoremap <F7> :Gcd<CR>:Ack <C-R><C-W><CR>
xnoremap <F7> y:Gcd<CR>:Ack '<C-R>"'<CR>
nnoremap <F8> :Gcd<CR>:Ack 
nnoremap <F9> :let fname=@%<CR>:Gcd<CR>:execute 'Ack ' fname<CR>

" gutentags {{{1
let g:gutentags_cache_dir='~/temp/gutentags'

" Netrw {{{1
nnoremap - :call util#Vinegar()<CR>
nnoremap <Leader>1 :call util#VinegarDrawer()<CR>

let g:netrw_keepdir   = 0
let g:netrw_hide      = 1
let g:netrw_list_hide = '.*\.swp$,.*\.meta$,.*\.suo$'
let g:netrw_banner    = 1
let g:netrw_altfile   = 0
" remove Netrw's annoying mappings
autocmd FileType netrw SmartUnmap('v')
autocmd FileType netrw SmartUnmap('o')
autocmd FileType netrw SmartUnmap('t')
autocmd FileType netrw SmartUnmap('T')

let g:netrw_bufsettings='nomodifiable nomodified nowrap readonly nobuflisted relativenumber'

" Path {{{1
set path+=**

" Unimpaired {{{1
nnoremap yom :call toggles#ToggleMouse()<CR>
nnoremap yoC :call toggles#ToggleColorColumn81()<CR>
nnoremap yoa :set invautochdir<CR>:set autochdir?<CR>

" vim-plug (vim-plug) {{{1
" https://github.com/junegunn/vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'mileszs/ack.vim'
Plug 'whiteinge/diffconflicts'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-gutentags'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vimwiki/vimwiki'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'junegunn/fzf.vim'
Plug 'stefandtw/quickfix-reflector.vim'

" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  " Both options are optional. You don't have to install fzf in ~/.fzf
  " and you don't have to run the install script if you use fzf only in Vim.
call plug#end()

" Unimpaired {{{1
nnoremap yom :call toggles#ToggleMouse()<CR>
nnoremap yoC :call toggles#ToggleColorColumn81()<CR>
nnoremap yoa :set invautochdir<CR>:set autochdir?<CR>

" vimwiki {{{1
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'auto_toc': 1, 'ext': '.md'}]
let g:vimwiki_folding='syntax'
let g:vimwiki_hl_cb_checked = 1
nnoremap gl* :VimwikiChangeSymbolTo \*<CR>
nnoremap yoz :call toggles#ToggleConcealLevel()<CR>

" if I put this in ftplugin, the mapping won't exist when opening a brand new
" *.md file from the command line
augroup MyVimWiki
	autocmd BufNewFile,BufRead *.md nnoremap <buffer> <Leader>D :call util#LogDiaryDate()<CR>
	autocmd BufNewFile,BufRead *.md set nocindent formatoptions=t textwidth=0 foldmethod=syntax expandtab

	" easy removal of [ ] tasks
	autocmd BufNewFile,BufRead *.md let @o="0f[4x"
augroup END

" -- FUNCTIONS -- {{{1
" this section is for functions not specifically associated with a plugin

function! SmartUnmap( char )
    if mapcheck( char, "N" ) != ""
        unmap <buffer> char
    endif
endfunction

function! Diff1HourAgo( timeSpec )
	exe 'earlier' a:timeSpec

	" yank current buffer paste in new vertical split
	silent %y
	silent vne
	silent 0put
	set bt=nofile

	" go to previous window and change it back by timespec
	wincmd p
	exe 'later' a:timeSpec

	windo diffthis
endfunction

function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction

function! SplitMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  20vnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
command! -nargs=+ -complete=command SplitMessage call SplitMessage(<q-args>)

command! -range Json <Line1>,<Line2>!python -m json.tool

function! ExtractHumanReadableSlotTime()
    " clear register 'a'
    :let @a=""

    call util#SlotTimeFormatHelper()

    " gather cutoffTime, startTime and endTime
    normal! gg
    call search('cutoffTime')
    normal! "ayy

    normal! gg
    call search('startTime')
    normal! "Ayy

    normal! gg
    call search('endTime')
    normal! "Ayy

    normal! gg
    call search('slotModCutoff')
    normal! "Ayy

    " replace entire file with those times
    normal! ggdG
    normal! "ap
    normal! kdd

    " call EpochToDateTime on all lines
    %call util#EpochToDateTime()

    " remove old epoch times
    %s/ "\d\{10}"//e
endfunction

function! TestToggle()
    let filename=@%
    Gcd
    if filename =~# '.*Test.java'
        let canonicalfile=expand('%:t:r')[:-(strlen('Test')+1)] . '.java'
        execute "find " . canonicalfile
    else
        execute "find " . expand('%:t:r') . "Test.java"
    endif
endfunction

"When editing a file, make screen display the name of the file you are editing
"Enabled by default. Either unlet variable or set to 0 in your .vimrc to disable.
let g:EnvImprovement_SetTitleEnabled = 1
function! SetTitle()
	if exists("g:EnvImprovement_SetTitleEnabled") && g:EnvImprovement_SetTitleEnabled && $TERM =~ "^screen"
		let l:title = 'vi: ' . expand('%:t')

		if (l:title != 'vi: __Tag_List__')
			let l:truncTitle = strpart(l:title, 0, 15)
			silent exe '!echo -e -n "\033k' . l:truncTitle . '\033\\"'
		endif
	endif
endfunction

function! PrettyPrintLogs()
    %s/{/{/g
    %s/}/}/g
    %s/\[/\[/g
    %s/\]/\]/g
    %s/,/,/g
    normal gg=G
    %s/}\_.\s*,/},/g
    %s/]\_.\s*,/],/g
endfunction

" easy logging {{{1
function! SetDebugRegisters()
    let @d="FLLogWarning( 'order-type-menuRMY_A $result ', $result );"
    let @e='FLLog::FLLogError( "" );'
endfunction
autocmd VimEnter :call SetDebugRegisters()<CR>

" trying this for ftl templates:
autocmd BufNewFile,BufRead *.nfg set suffixesadd+=.ftl filetype=json
autocmd BufNewFile,BufRead *.ftl set filetype=xml suffixesadd+=.ftl

" misc notes {{{1
"
" ------ search for bar not in foobar:  {{{2
"         Example                 matches
"         \(foo\)\@<!bar          any "bar" that's not in "foobar" (i.e. not preceded by "foo")

" ------ searching over multiple lines:  {{{2
" Finds abc followed by any characters or newlines (as few as possible) then def.
"         /abc\_.\{-}def

"         /<!--\_.\{-}-->
" The atom \_. finds any character including end-of-line. 
"  
" ------ looping over a whole file:  {{{2
" :while line('.') != line('$') | exec "normal \<C-F>" | redraw | sleep 1 | endwhile
" comes in handy when wanting to scroll thru numerous files via a recorded macro

" ------ going back when you've pressed <Space> too many times {{{2
" The |g<| command can be used to see the last page of previous command output.
" useful if you accidentally typed <Space> at the hit-enter prompt.
"
" ------ using g {{{2
" :g/<pattern>/z#.5                           " Display context (5 lines) for all occurrences of a pattern
" :g/<pattern>/z#.5|echo "=========="         " Same, but with some beautification.
" 
" ------ pull WORD under the cursor into a command line or search {{{2
" <C-R><C-A>
"
" vim:ft=vim:fdm=marker
