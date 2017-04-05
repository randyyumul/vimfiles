" Color Switching {{{1

let s:mycolors=''
set runtimepath+=/usr/local/Cellar/vim/8.0.0055/share/vim/vim80/colors
function! SetColors()
    let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    let s:mycolors = map(paths, 'fnamemodify(v:val, ":t:r")')
endfunction

function! PrintColors()
    echo 'List of colors set from all installed color schemes'
    let colorlist = ''
    for i in range(len(s:mycolors))
        if exists('g:colors_name') && g:colors_name == s:mycolors[i]
            let colorlist.=' ['.s:mycolors[i]. '] '
        else
            let colorlist.=' '.s:mycolors[i]
        endif
    endfor
    echo "colorlist: " .colorlist
endfunction

function! NextColor(how)
    if len(s:mycolors) == 0
        call SetColors()
    endif

    let current = -1
    if exists('g:colors_name')
        let current = index(s:mycolors, g:colors_name)
    endif
    for i in range(len(s:mycolors))
        if a:how == 0
            let current = localtime() % len(s:mycolors)
            let a:how = 1  " in case random color does not exist
        else
            let current += a:how
            if  current > len(s:mycolors)-1
                let current=0
            elseif current < 0
                let current=len(s:mycolors)-1
            endif
        endif
        try
            execute 'colorscheme '.s:mycolors[current]
            redraw!
            break
        catch /E185:/
            call add(missing, s:mycolors[current])
        endtry
    endfor
    call PrintColors()
    echo "current: " .s:mycolors[current]
endfunction

