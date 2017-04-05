" utility functions to be called from vimrc

" emulate vim vinegar (editing current directory)
" without killing the search register
function! util#Vinegar()
    let tmp=@"
    let @"=@%
    edit .
    call search(@")
    let @"=tmp
endfunction

" eliminate all but the current buffer
function! util#BufOnly()
    let buffer = bufnr('%')
	if buffer == -1
		echohl ErrorMsg
		echomsg "No matching buffer for" buffer
		echohl None
		return
	endif

	let last_buffer = bufnr('$')

	let delete_count = 0
	let n = 1
	while n <= last_buffer
		if n != buffer && buflisted(n)
            silent exe 'bdelete ' . n
            if ! buflisted(n)
                let delete_count = delete_count+1
            endif
		endif
		let n = n+1
	endwhile

	if delete_count == 1
		echomsg delete_count "buffer deleted"
	elseif delete_count > 1
		echomsg delete_count "buffers deleted"
	endif
endfunction

" mark tasks done in log files
function! util#ToggleDone()
    " mark current task intermediary done
    s/^\(\s*\)-/\1=/e

    " mark current task intermediary not done
    s/^\(\s*\)x/\1x/e

    " mark current task done
    s/^\(\s*\)=/\1+/e

    " mark current task not done
    s/^\(\s*\)x/\1-/e

    " allow search for the next TODO item
    let @/ = '^\s*\zs-'
    set hlsearch
endfunction

" log the date and open the previous day's log file
function util#LogDate()
    0r!date
    vsplit
    wincmd h
    normal [fgg
endfunction

" set modifiable state of buffer to match readonly state (unless overridden manually)
function! util#UpdateModifiable()
	if &readonly
		setlocal nomodifiable
	else
		setlocal modifiable
	endif
endfunction

" convert a unix time to human readable format
function! util#EpochToDateTime()
    call search('\d\{10}')
    normal! ye
    execute 'r!date -u -jf "\%s" ' . @0 . ' "\%a \%b \%d \%T \%Z \%Y"'
    normal! kJ
endfunction

" put unix time on same line as variable name
function! util#SlotTimeFormatHelper()
    %s/\(cutoffTime\)\n\("\d\{10}"\)/\1 = \2/e
    %s/\(startTime\)\n\("\d\{10}"\)/\1 = \2/e
    %s/\(endTime\)\n\("\d\{10}"\)/\1 = \2/e
endfunction
