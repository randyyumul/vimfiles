" ------------------------------------------------
" Randy Yumul's amazon vimrc
" ------------------------------------------------
"
filetype off

" must do this before any other mappings
let mapleader = "\<Space>"

" map <CR> to : but not for quickfix or command windows!!!
" thanks to /u/meribold in this post: https://www.reddit.com/r/vim/comments/4m678o/best_way_to_remap_cr_in_normal_mode/
nnoremap <expr> <CR> empty(&buftype) \|\| &bt ==# 'help' \|\| &ft ==# 'man' ?  ':' : '<CR>'
xnoremap <expr> <CR> empty(&buftype) \|\| &bt ==# 'help' \|\| &ft ==# 'man' ?  ':' : '<CR>'

nnoremap <Leader>h :noh<CR>
xnoremap <Leader>h :<C-U>noh<CR><ESC>gv
nnoremap <Leader>; yiw<C-W>vgg/<C-R>0<CR>:noh<CR>

" reset all autocmds
autocmd!

" auto reading/writing  {{{1
set autoread                             " auto read externally modified files
set autochdir                            " automatically cd to dir of file in current buffer

set sessionoptions-=options

autocmd BufReadPost * call UpdateModifiable()

" UI {{{1
set backspace=eol,start,indent           " make backspace better
if version == 800
    set belloff=all                      " disallow annoying bell sound
endif
set cmdheight=2                          " number of lines to use for the command-line
if findfile("~/dotfiles/spell/en.utf-8.add") != ""
    set dictionary+=~/dotfiles/spell/en.utf-8.add
    set spellfile=~/dotfiles/spell/en.utf-8.add
endif
set hidden                               " deal with multiple buffers better
set history=1000                         " remember more than 20 commands
set linebreak                            " break at a word boundary
set mouse=a                              " allow use of mouse
set number                               " Turn on line numbering
set nrformats-=alpha
if version == 800
	set relativenumber                       " Turn on relative line numbering
endif
set shortmess=imt                        " clean up the 'Press ENTER ...' prompts
set showmode                             " show -- INSERT --, etc.
set showcmd                              " show stuff in the status line area
set splitright                           " new window is put right of the current one
set title                                " set terminal title
set undofile                             " automatically save undo history to an undo file when writing a buffer to a file
if isdirectory($HOME . '/temp/vimundo') == 0
    silent !mkdir -p ~/temp/vimundo > /dev/null 2>&1
endif
set undodir=~/temp/vimundo
set ttimeoutlen=0                        " time in milliseconds that is waited for a key code or mapped key
set wildmenu                             " enhanced file/command tab completion
set wildmode=list:longest,full           " set file/command completion mode
										 " list:longest      When more than one match, list all matches and
										 "                    complete till longest common string.
										 "
										 " full"              Complete the next full match.  After the last match,
										 "                    the original string is used and then the first match
										 "                    again.
set wildignore=*.meta,*.swp,*.bak        " ignore these files when auto-completing files
set wildcharm=<C-Z>
set nowrap                               " default to display no line wrapping
set fillchars=""                         " get rid of the characters in window separators
set diffopt+=vertical                    " start 'diffthis' vertically by default
if has("gui")
	set guioptions-=T                    " remove toolbar
	set guioptions-=m                    " remove drop down menu
	" set guioptions-=b                    " allow horizontal scrollbar
	set guioptions-=L                    " left scrollbar when split
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

runtime macros/matchit.vim           " extend % matching (on osx, better to copy plugin into .vim directory)

" suppress DoMatchParen
let loaded_matchparen = 1

colorscheme default
" run this command to set all the different color schemes that I like
if exists(":SetColors")
    SetColors badwolf jellybeans solarized desert zellner morning asmdev koehler ChocolateLiquor molokai zenburn evening torte darkeclipse kalisi primary
    " run this to reset to using all installed colorschemes
    " SetColors all
endif
" set background coloring
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

" easier exiting of cmd window
autocmd CmdwinEnter * nnoremap <buffer> q :q<CR>
set cmdwinheight=11   " show last 10 items in cmdwin history

" remove suspend keystroke
nnoremap <C-Z> <Nop>

" indentation {{{1
set autoindent                           " autoindent
set shiftwidth=4                         " tab size
set tabstop=4                            " tab size
set expandtab                            " use spaces instead of tabs :-(
set listchars=tab:>.,trail:.,extends:\

" searching {{{2
set gdefault                             " default /g in substs
set hlsearch                             " highlight matched text
set incsearch                            " incremental search
set ignorecase                           " by default ignore case
set nowrapscan

" syntax highlighting                    {{{1
syntax on                                " enable syntax highlighting
filetype on                              " enable filetype detection
filetype indent on                       " enable filetype-specific indenting
filetype plugin on                       " enable filetype-specific plugins

" MODE MAPPINGS {{{1

" TIP: way to check if mapping is already taken:
" :echo mapcheck(';g', 'n')   " first arg is keymap, second is mode
" also can us hasmapto() for reverse lookup

nnoremap Y y$

" windows-esque mappings {{{2
nnoremap <C-C> "+yy
vnoremap <C-C> "+y
noremap  <C-V> "+p

" easier pasting from clipboard {{{2
inoremap <F1> <C-R>+

" better way to press escape: {{{2
inoremap jj <Esc>
inoremap kk <Esc>
inoremap kj <Esc>:wa<CR>
inoremap jk <Esc>:wa<CR>
cnoremap kj <Esc>
cnoremap jk <Esc>
cnoremap jj <Esc>
cnoremap kk <Esc>

" more intuitive j and k {{{2
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk
nnoremap gj j
nnoremap gk k
xnoremap gj j
xnoremap gk k

" swap 0 and ^ {{{2
nnoremap 0 ^
nnoremap ^ 0

" quick beginning and end of line in insert mode {{{2
inoremap <C-J><C-H> <C-O>^
inoremap <C-J><C-L> <End>

" copy entire line and paste before the current line and comment {{{2
nnoremap _ yyp
nmap <Leader>_ yypgcc

" quick way to do search and replace {{{2
vnoremap <Leader>r y:%s/<C-R>0/

" quick way to do operate on a selection of lines {{{2
xnoremap <Leader>n :normal<Space>

" Pull word under cursor into LHS of a substitute
nnoremap <leader>r :%s#\<<c-r>=expand("<cword>")<cr>\>#

" repeat last search but enforce case sensitivity
nnoremap z/ /<Up>\C<CR>

" search within a selection (press Alt-/ to search w/in the visually selected area) {{{2
vnoremap <Leader>/ <Esc>/\%V

" better way to execute macros (assuming macro was recorded to register 'q') {{{2
nnoremap Q @q

" paste from search register better {{{2
inoremap <C-R>/ <C-O>:call formatting#StripSearchRegister()<CR><C-R>/
cnoremap <C-R>/ <C-R>/<BackSpace><BackSpace><S-Left><Delete><Delete><S-Right>

" better undo
inoremap <C-W> <C-G>u<C-W>

" complete options
"   . = current buffer
"   w = windows
"   b = buffers
"   u = unloaded buffers
"   t = tag completion
set complete=.,w,b,u,t

" easy line completion {{{2
inoremap <C-L> <C-X><C-L>

" better navigating through tabs {{{2
nnoremap <silent> <Leader>tc :tabclose<CR>
nnoremap <silent> <Leader>td :windo bd<CR>
nnoremap <silent> <Leader>to :tabonly<CR>
nnoremap <Leader>b :ls<CR>:b
nnoremap <silent> <C-Left> :tabmove -1<CR>
nnoremap <silent> <C-Right> :tabmove +1<CR>

" better navigating back thru files {{{2
nnoremap <Leader><C-O> :jumps<CR>:normal <C-O><Left>

" navigating back thru changes {{{2
nnoremap <Leader><C-G> :changes<CR>:normal g;<Left><Left>

" REALLY want to close a buffer {{{2
nnoremap <Leader>Q :bd!<CR>

" better way to do bufdelete or 'bd' and window closing {{{2
nnoremap <Leader>q :bd<CR>
nnoremap <Leader>w :wincmd c<CR>

" 'e'dit 'v'imrc, and 's'ource 'v'imrc, respectively) {{{2
nnoremap <silent> <Leader>et :edit ~/Library/Application\ Support/Notational\ Data/TODO.txt<CR>
nnoremap <silent> <Leader>ev :edit ~/dotfiles/vimfiles/vimrc<CR>
nnoremap <silent> <Leader>v :tabnew ~/dotfiles/vimfiles/vimrc<CR>
nnoremap <silent> <Leader>sv :source ~/dotfiles/vimfiles/vimrc<CR>
nnoremap <silent> <Leader>ez :edit $HOME<CR>

" edit latest log
command! Journal :execute "edit ~/journal/log" . strftime("%Y-%m-%d") . ".txt"

" yank filename to clipboard {{{2
nnoremap <Leader>y% :let @+=expand('%')<CR>:let @"=expand('%')<CR>
nnoremap <Leader>Y% :let @+=expand('%:p')<CR>:let @"=expand('%:p')<CR>

" almost always want block select over regular visual. To get regular visual mode, just press 'v' again. {{{2
nnoremap v <C-q>

" visually search for highlighted text
xnoremap * y/<C-R>"<CR>
xnoremap # y?<C-R>"<CR>

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

" edit current file in a new tab {{{2
nnoremap <silent> <Leader>te <C-W>T

" easy to move to next/prev tab {{{2
nnoremap t gt
nnoremap T gT

" easy open new tab {{{2
nnoremap <silent> go :tabnew<CR>
" do it this way so edited files can still be opened in a new tab {{{2
nnoremap <silent> <Leader>go :tabnew<CR>:edit #<CR>

" easy vertical window opening {{{2
nnoremap <silent> gl <C-W>v

" put current line at top of window -15 lines (NOTE: overrides 'zg', which {{{2
" added a misspelled word to the dictionary)
nnoremap zg zt15<C-Y>

" quicker to correct spelling
nnoremap z- 1z=

" nice way of opening/closing quickfix window {{{2
nnoremap <silent> cv :call toggles#QuickFixToggle()<CR>

" navigate through occurrences of previous search w/in current file
nnoremap g/ :g/<C-R><C-W>/#<CR>:
vnoremap g/ y:g/<C-R>0/#<CR>:

" lookup word under cusror in vim help
autocmd FileType vim nnoremap <buffer> K yiw:help <C-R>"<CR>

" Return to last edit position when opening files (You want this!) '\" is the cursor position when last exiting the current buffer {{{2
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

autocmd BufNewFile,BufRead *.hsm set filetype=hsm
autocmd BufNewFile,BufRead *.mi set filetype=perl

" Using BufLeave with this autocmd disallows the use of ToggleDiffOrig() {{{2
if version == 800
	augroup RMYGroup
		autocmd!
		autocmd RMYGroup InsertEnter * set norelativenumber
		autocmd RMYGroup InsertEnter * set number
		autocmd RMYGroup InsertLeave * set relativenumber
		autocmd RMYGroup InsertLeave * set nonumber
		autocmd RMYGroup WinLeave * set norelativenumber
		autocmd RMYGroup WinEnter * set relativenumber
	augroup END
endif

" comment out large blocks of text
vnoremap <Leader>,/ <Esc>:call formatting#VPoundCommentOut()<CR>

" formatting: {{{2
nnoremap <Leader>ss :call formatting#StripTrailingWhitespaces()<CR>
nnoremap <Leader>sk vi{:v/\S/d<CR>:noh<CR>
vnoremap <Leader>sk :v/\S/d<CR>:noh<CR>

" quickly make a scratch buffer
command! Scratch set buftype=nofile
command! SC set buftype=nofile

" delete all but this buffer (must save first) 'Buffer Only'
command! BOnly call util#BufOnly()

" more text objects, courtesy of romainl:
" https://www.reddit.com/r/vim/comments/4d6q0s/weekly_vim_tips_and_tricks_thread_4/
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '`' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" switch from backslashes to forward slashes {{{2
nnoremap <Leader>\/ :s/\\/\//<CR>:noh<CR>
nnoremap <Leader>\\ :s/\//\\/<CR>:noh<CR>

" Experimental: go back and forth in undo tree using CTRL-ScrollWheel
nnoremap <C-ScrollWheelDown> g-
nnoremap <C-ScrollWheelUp> g+

" Abbreviations {{{1

cnoremap %% <C-r>=expand('%:p')<CR>

" mapping for :windo and :bufdo
cabbrev wdt windo diffthis

iabbrev HACK HACK HACK HACK

" print a long commented line
iabbrev //- //-------------------------------------------------------------------------
iabbrev /// //---------------------------------

nnoremap <Leader>= yypVr-==

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
nnoremap cof :call toggles#ToggleFoldMethod()<CR>

" difforig {{{1
if !exists(":DiffOrig")
  command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" 'd'iff 'o'rig, and use 'd'iff key 'm'apping
nnoremap <Leader>do :call formatting#ToggleDiffOrig()<CR>
nnoremap <Leader>dh :call Diff1HourAgo( '1h' )<CR>

" Ag {{{1
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor 

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" ClosePair {{{1
inoremap ( ()<ESC>i
inoremap ) <c-r>=formatting#ClosePair(')')<CR>
inoremap { {}<ESC>i
inoremap } <c-r>=formatting#ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=formatting#ClosePair(']')<CR>

" Commentary {{{1
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
autocmd FileType cfg setlocal commentstring=#\ %s
nmap gh gc
nmap ghg gcc
nmap ghh gcc
vmap gh gc

" CtrlP {{{1
let g:ctrlp_cmd = 'CtrlPMRUFiles'

" EasyAlign {{{1
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Netrw {{{1
nnoremap - :call util#Vinegar()<CR>

let g:netrw_keepdir   = 0
let g:netrw_hide      = 1
let g:netrw_list_hide = '.*\.swp$,.*\.meta$,.*\.suo$'
let g:netrw_banner    = 1
let g:netrw_altfile   = 0
" remove Netrw's annoying mappings
autocmd FileType netrw unmap <buffer> v
autocmd FileType netrw unmap <buffer> o
autocmd FileType netrw unmap <buffer> t
autocmd BufNewFile,BufRead log* nnoremap <buffer> <Leader>D :call util#LogDate()<CR>
autocmd BufNewFile,BufRead log* nnoremap <buffer> <Leader>x :set nohlsearch<CR>:call util#ToggleDone()<CR>
let g:netrw_bufsettings='noma nomod nowrap ro nobl rnu'

" Path {{{1
set path+=**

" Unimpaired {{{1
nnoremap cob :set background=<C-R>=&background == 'dark' ? 'light' : 'dark'<CR><CR>:set background?<CR>
nnoremap com :call toggles#ToggleMouse()<CR>
nnoremap coS :set invsmartcase<CR>:set smartcase?<CR>
nnoremap coP :call toggles#ToggleRecursivePath()<CR>
nnoremap coC :call toggles#ToggleColorColumn81()<CR>
nnoremap cop :set invpaste<CR>:set paste?<CR>

" -- FUNCTIONS -- {{{1
" this section is for functions not specifically associated with a plugin

" set modifiable state of buffer to match readonly state (unless overridden manually)
function! UpdateModifiable()
	if &readonly
		setlocal nomodifiable
	else
		setlocal modifiable
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
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

function! JsonToReadable()
	%s/,/,\r/
	%s/{/{\r
	%s/}/}\r
	%s/^"/	"/
	noh
endfunction

function! ExtractHumanReadableSlotTime()
    " clear register 'a'
    :let @a=""

    " gather cutoffTime, startTime and endTime
    normal! gg
    call search('cutoffTime')
    normal! "ayy
    call search('startTime')
    normal! "Ayy
    normal! gg
    call search('endTime')

    " replace entire file with those times
    normal! "Ayy
    normal! ggdG
    normal! "ap
    normal! kdd

    " call EpochToDateTime on all lines
    %call EpochToDateTime()

    " remove old epoch times
    %s/ "\d\{10}"//
endfunction

function! EpochToDateTime()
    call search('\d\{10}')
    normal! ye
    execute 'r!date -u -jf "\%s" ' . @0 . ' "\%a \%b \%d \%T \%Z \%Y"'
    normal! kJ
endfunction

command! Prose call toggles#ProseToggle()

" easy logging {{{1
function! SetDebugRegisters()
    let @d="FLLogWarning( 'order-type-menuRMY_A $result ', $result );"
    let @e='FLLog::FLLogError( "" );'
endfunction
autocmd VimEnter :call SetDebugRegisters()<CR>

" misc notes {{{1
"
" ------ search for bar not in foobar:  {{{2
"         Example                 matches
"         \(foo\)\@<!bar          any "bar" that's not in "foobar" (i.e. not preceded by "foo")

" ------ searching over multiple lines:  {{{2
" Finds abc followed by any characters or newlines (as few as possible) then def.
"         /abc\_.\{-}def

"         /<!--\_.\{-}-->
" The atom \_. finds any character including end-of-line. The multi \{-} matches as few as possible 
" (stopping at the first "-->"; the multi * is too greedy and would stop at the last occurrence).
"  
" ------ looping over a whole file:  {{{2
" :while line('.') != line('$') | exec "normal \<C-F>" | redraw | sleep 1 | endwhile
" comes in handy when wanting to scroll thru numerous files via a recorded macro
"
" ------ NotScripts password{{{2
" ohsaycanyouseebythedawnsearlylight

" ------ going back when you've pressed <Space> too many times {{{2
" The |g<| command can be used to see the last page of previous command output.
" This is especially useful if you accidentally typed <Space> at the hit-enter
" prompt.
"
" ------ using g {{{2
" :g/^\s*$/d          " delete all blank lines
"
" :g/<pattern>/z#.5                           " Display context (5 lines) for all occurrences of a pattern
" :g/<pattern>/z#.5|echo "=========="         " Same, but with some beautification.
" 
" ------ pull WORD under the cursor into a command line or search {{{2
" <C-R><C-A>
"
" vim:ft=vim:fdm=marker
