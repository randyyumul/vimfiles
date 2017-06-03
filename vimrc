" ------------------------------------------------
" Randy Yumul's amazon vimrc
" ------------------------------------------------

filetype off

" must do this before any other mappings
let mapleader = "\<Space>"

" map <CR> to : but not for quickfix or command windows!!!
" thanks to /u/meribold in this post: https://www.reddit.com/r/vim/comments/4m678o/best_way_to_remap_cr_in_normal_mode/
nnoremap <expr> <CR> empty(&buftype) \|\| &bt ==# 'help' \|\| &ft ==# 'man' ?  ':' : '<CR>'
xnoremap <expr> <CR> empty(&buftype) \|\| &bt ==# 'help' \|\| &ft ==# 'man' ?  ':' : '<CR>'

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
if findfile("~/dotfiles/spell/en.utf-8.add") != ""
    set dictionary+=~/dotfiles/spell/en.utf-8.add
    set spellfile=~/dotfiles/spell/en.utf-8.add
endif
set hidden                               " deal with multiple buffers better
set history=1000                         " remember more than 20 commands
set linebreak                            " break at a word boundary
set number                               " Turn on line numbering
if version == 800
	set relativenumber                   " Turn on relative line numbering
	set number                           " Turn on absolute line numbering
endif
set shortmess=imt                        " clean up the 'Press ENTER ...' prompts
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
set wildcharm=<C-Z>
set nowrap                               " default to display no line wrapping
set fillchars=""                         " get rid of the characters in window separators
set diffopt+=vertical                    " start 'diffthis' vertically by default
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

runtime macros/matchit.vim           " extend % matching (on osx, better to copy plugin into .vim directory)

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
set expandtab                            " use spaces instead of tabs :-(
set listchars=eol:\$,tab:>.,trail:.,extends:\

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
inoremap <C-B> <Esc>"+pa

" better way to press escape: {{{2
inoremap jj <Esc>:wall<CR>
inoremap kk <Esc>:wall<CR>
inoremap kj <Esc>:wall<CR>
inoremap jk <Esc>:wall<CR>
cnoremap kj <Esc>
cnoremap jk <Esc>
cnoremap jj <Esc>
cnoremap kk <Esc>

" 1-keystroke save {{{2
nnoremap <F5> :wall<CR>

" capitalize previously typed word
inoremap <C-F> <Esc>vbgUea<Space>

" swap 0 and ^ {{{2
nnoremap 0 ^
nnoremap ^ 0

" easier way to alternate between 2 files {{{2
nnoremap <Leader>a :b#<CR>

" quick beginning and end of line in insert mode {{{2
inoremap <C-G><C-H> <C-O>^
inoremap <C-G><C-L> <End>

" copy entire line and paste before the current line and comment {{{2
nnoremap _ yyp
nmap <Leader>_ yypgcc

" quick way to do search and replace {{{2
vnoremap <Leader>r y:%s/<C-R>0/
nnoremap <Leader>r :%s//<Left>

" quick way to do case sensitive search {{{2
nnoremap c/ /\C

" quick way to add a new search to current search {{{2
nnoremap \| /<C-R><C-W>\\|<C-R>/<CR>
xnoremap \| y/<C-R>0\\|<C-R>/<CR>

" navigate through occurrences of previous search w/in current file
nnoremap g/ :g/<C-R><C-W>/#<CR>:normal! ``<CR>:
vnoremap g/ y:g/<C-R>0/#<CR>:normal! ``<CR>:

" repeat last search but enforce case sensitivity
nnoremap z/ /<Up>\C<CR>

" repeat search but within a highlighted selection  {{{2
vnoremap <Leader>/ <Esc>/\%V<C-R><C-R>/<CR>

" better way to execute macros (assuming macro was recorded to register 'q') {{{2
nnoremap Q @q

" paste from search register better {{{2
inoremap <C-R>/ <C-O>:call formatting#StripSearchRegister()<CR><C-R>/

" paste from registers easier (note the trailing space) {{{2
nnoremap <Leader>p :display<CR>:put 
" paste using Alt-P
inoremap π <C-O>:SplitMessage reg<CR><C-O>:wincmd p<CR><C-O>:put 

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

" better navigating through tabs {{{2
nnoremap <silent> <Leader>tc :tabclose<CR>
nnoremap <silent> <Leader>td :windo bd<CR>
nnoremap <silent> <Leader>to :tabonly<CR>
nnoremap <Leader>b :ls<CR>:b
nnoremap <silent> <C-Left> :tabmove -1<CR>
nnoremap <silent> <C-Right> :tabmove +1<CR>

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
if findfile("~/Library/Application\ Support/Notational\ Data/TODO.txt") != ""
    nnoremap <silent> <Leader>et :edit ~/Library/Application\ Support/Notational\ Data/TODO.txt<CR>
endif
nnoremap <silent> <Leader>ev :edit ~/dotfiles/vimfiles/vimrc<CR>
nnoremap <silent> <Leader>sv :source ~/dotfiles/vimfiles/vimrc<CR>
nnoremap <silent> <Leader>ez :edit $HOME<CR>

" yank filename to clipboard {{{2
nnoremap <Leader>y% :let @+=expand('%')<CR>:let @"=expand('%')<CR>
nnoremap <Leader>Y% :let @+=expand('%:p')<CR>:let @"=expand('%:p')<CR>

" almost always want block select over regular visual. To get regular visual mode, just press 'v' again. {{{2
nnoremap v <C-q>

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

autocmd BufNewFile,BufRead *.mi,*.pm set filetype=perl
autocmd BufNewFile,BufRead *.mi,*.pm nnoremap <buffer> [m :let tmpsearch=@/<CR>?^sub<CR>:let @/=tmpsearch<CR>
autocmd BufNewFile,BufRead *.mi,*.pm nnoremap <buffer> ]m :let tmpsearch=@/<CR>/^sub<CR>:let @/=tmpsearch<CR>

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

" comment out large blocks of text
vnoremap <Leader>,/ <Esc>:call formatting#VPoundCommentOut()<CR>

" formatting: {{{2
nnoremap <Leader>ss :call formatting#StripTrailingWhitespaces()<CR>

" CUSTOM COMMANDS {{{2

" edit latest log
command! Journal :execute "edit ~/journal/log" . strftime("%Y-%m-%d") . ".txt"
autocmd BufNewFile,BufRead log* nnoremap <buffer> <Leader>D :call util#LogDate()<CR>
autocmd BufNewFile,BufRead log*,*TODO.txt nnoremap <buffer> <Leader>x :set nohlsearch<CR>:call util#ToggleDone()<CR>
autocmd BufNewFile,BufRead log*,*TODO.txt nnoremap <buffer> <Leader>X :set nohlsearch<CR>:call util#ToggleProgress()<CR>
autocmd BufNewFile,BufRead log* set filetype=help nocindent formatoptions=t textwidth=110

" easy date/time insertion
command! Date :normal a<C-R>=strftime("\%Y-\%m-\%d")<CR>
command! Time :normal a<C-R>=strftime("\%H:\%M:\%S")<CR>

" quickly make a scratch buffer
command! Scratch set buftype=nofile
command! SC set buftype=nofile

" toggle prose settings
command! Prose call toggles#ProseToggle()

" delete all but this buffer (must save first) 'Buffer Only'
command! BOnly call util#BufOnly()

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

" mapping for :windo and :bufdo
cabbrev wdt windo diffthis

iabbrev HACK HACK HACK HACK

" print a long commented line
iabbrev //- //-------------------------------------------------------------------------
nnoremap + o<Esc>i-------------------------------------------------------------------------<Esc>
nnoremap <Leader>+ o<Esc>:call PutTitle()<CR>
inoremap <C-]> <Esc>o-------------------------------------------------------------------------<Esc>
inoremap <C-_> <C-O>:call PutTitle()<CR>

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
    let g:ackprg = "ag --vimgrep"
    cnoreabbrev ag Ack
    set shellpipe=&>

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

" Color switching {{{1
nnoremap <F8> :call NextColor(1)<CR>
nnoremap <S-F8> :call NextColor(-1)<CR>

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
xmap ga :EasyAlign //<Left>

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" <C-/> to get into regular expression mode
nmap ga <Plug>(EasyAlign)

" Fugitive {{{1
nnoremap \ :Gcd<CR>:pwd<CR>

" search from the top level .git directory for word under the cursor
" (chose F7 because CMD+F7 is show variable usage w/in IntelliJ)
nnoremap <F7> :Gcd<CR>:Ack <C-R><C-W><CR>
xnoremap <F7> y:Gcd<CR>:Ack '<C-R>"'<CR>

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
let g:netrw_bufsettings='noma nomod nowrap ro nobl rnu'

" nValt Notes {{{1
nnoremap <Leader>en :cd /Users/ryumul/Library/Application\ Support/Notational\ Data/<CR>:e <C-D><C-U>Ack<Space>

" Path {{{1
set path+=**

" Unimpaired {{{1
nnoremap com :call toggles#ToggleMouse()<CR>
nnoremap coS :set invsmartcase<CR>:set smartcase?<CR>
nnoremap coP :call toggles#ToggleRecursivePath()<CR>
nnoremap coC :call toggles#ToggleColorColumn81()<CR>
nnoremap cop :set invpaste<CR>:set paste?<CR>
nnoremap coa :set invautochdir<CR>:set autochdir?<CR>

" -- FUNCTIONS -- {{{1
" this section is for functions not specifically associated with a plugin

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

function! JsonToReadable()
    %s/\\"/\"/
	%s/,/,\r/
	%s/{/{\r
	%s/}/}\r
	%s/^"/	"/
    %s/\\n//
    %s/\\t/	/
    %s/\\"/"/
	noh
endfunction

function! ExtractHumanReadableSlotTime()
    " clear register 'a'
    :let @a=""

    call util#SlotTimeFormatHelper()

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
    %call util#EpochToDateTime()

    " remove old epoch times
    %s/ "\d\{10}"//e
endfunction

function! PutTitle()
        normal! V99<c$-------------------------------------------------------------------------
        normal! 10|
        startreplace
endfunction

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
