" toggle functions to be called from vimrc

function! toggles#ToggleColorColumn81()
	if &colorcolumn == ""
		set colorcolumn=81
	else
		set colorcolumn=
	endif
endfunction

function! toggles#ToggleConcealLevel()
    let &conceallevel = (&conceallevel + 1) % 3
    set conceallevel?
endfunction

function! toggles#ToggleMouse()
	if &mouse == ""
		set mouse=a
	else
		set mouse=
	endif
    set mouse?
endfunction

function! toggles#ToggleFoldMethod()
	if &foldmethod == "manual"
		set foldmethod=indent
	elseif &foldmethod == "indent"
		set foldmethod=syntax
	elseif &foldmethod == "syntax"
		set foldmethod=marker
	elseif &foldmethod == "marker"
		set foldmethod=manual
    else
		set foldmethod=syntax
	endif
	set foldmethod?
endfunction

let g:recursive_path = 0
let g:saved_path=&path
function! toggles#ToggleRecursivePath()
	if g:recursive_path == 0
		let g:recursive_path = 1
		let g:saved_path = &path
		set path=.
		set path+=**
	elseif g:recursive_path == 1
		let g:recursive_path = 0
		execute "set path=" . g:saved_path
	endif
	set path?
endfunction

function! toggles#ToggleBackground()
	if &background == "light"
		set background=dark
	else
		set background=light
	endif
endfunction

function! toggles#QuickFixToggle()
	for i in range(1, winnr('$')) 
		let bnum = winbufnr(i) 
		if getbufvar(bnum, '&buftype') == 'quickfix' 
			cclose 
			return 
		endif 
	endfor 

	copen 
endfunction 

" write prose
function! toggles#ProseToggle()
	if &spell==0
		setlocal spell
		setlocal wrap
		setlocal tw=0
		let g:saved_fmtoptions = &formatoptions
		setlocal formatoptions=2tcq
		setlocal noautoindent
		echom "Toggled Prose On!"
		call ProseScreen()
	else
		setlocal nospell
		setlocal nowrap
		setlocal textwidth=150
		execute 'set formatoptions=' . g:saved_fmtoptions
		setlocal autoindent
		echom "Toggled Prose Off!"
	endif
endfunction

" create prose writing screen
function! ProseScreen()
    botright 45vne
	wincmd p
    topleft 45vne
	wincmd p
endfunction

