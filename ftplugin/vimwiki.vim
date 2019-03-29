" standard vim mapping for following links
nmap <buffer> g- <Plug>VimwikiRemoveHeaderLevel
nmap <buffer> g= <Plug>VimwikiAddHeaderLevel

augroup MyVimWiki
	autocmd BufNewFile,BufRead *.md nnoremap <buffer> <Leader>D :call util#LogDiaryDate()<CR>
	autocmd BufNewFile,BufRead *.md set nocindent formatoptions=t textwidth=0 foldmethod=syntax expandtab

	" easy removal of [ ] tasks
	autocmd BufNewFile,BufRead *.md let @o="0f[4x"
augroup END

