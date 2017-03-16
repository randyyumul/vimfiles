" formatting related functions to be called from vimrc

" strip trailing white spaces
function! formatting#StripTrailingWhitespaces()
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	" remove carriage-return characters
	%s/\r//ge
	" remove trailing whitespace
	%s/\s\+$//e
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

" remove the \< \> from the search register
function! formatting#StripSearchRegister()
	let @/=substitute( @/, "\\\\<\\|\\\\>", "", "g" )
endfunction

" surround a block of visually selected text w/ "#if 0" and "#endif"
function! formatting#VPoundDefOut()
    normal '<O#if false
	normal '>o#endif
	normal <C-O<C-O>
endfunction

function! formatting#VPoundCommentOut()
    normal '<O/*
	normal '>o*/
	normal <C-O<C-O>
endfunction

" helper function to diff an unsaved file
function! formatting#ToggleDiffOrig()
	if &diff
		diffoff!
		windo if &buftype == 'nofile' | bdelete | endif
	else
		DiffOrig
	endif
endfunction

" helper to close braces,parens,etc.
function! formatting#ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction

