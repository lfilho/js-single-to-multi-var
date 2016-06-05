" ==============================================
" Example on how to map it (also on the README):
" ==============================================

" autocmd FileType js,javascript,javascript.jsx noremap <silent> <Leader>; :call toMultiVar#singleToMultiVar()<CR>

" ------------
" Assumptions:
" - One variable per line
" - Blocks (functions, object, arrays) should have their openings brackets
"   as the line's last char
" - "Comma last" style (commas are at the end of the line instead of in the
"   beggining
" - No comments after var declarations (in the same line)

fun! toMultiVar#singleToMultiVar()
    let b:originalCursorPosition = getpos('.')

    norm! G
    while s:hasMultilineVar()
        call s:convertDeclarationBlock()
    endwhile

    call setpos('.', b:originalCursorPosition)
endfun

fun! s:hasMultilineVar()
    return search('^\s*var.\+,$', 'bW') > 0
endf

" The real magic:
fun! s:convertDeclarationBlock()
    let b:currentLine = s:getCurrentLine()

    if s:startsWith('//')
        call s:reindentLine()
        norm! j
        let b:currentLine = s:getCurrentLine()
    endif

    if s:endsWith(';')
        if !s:startsWith('var')
            call s:prependVar()
        endif

        return
    endif

    if s:endsWith('[(\[{]')
        if !s:startsWith('var')
            call s:prependVar()
        endif

        " Realigns block and go to its ending line:
        norm! $=%$%
    endif

    if s:endsWith(',')
        exec 's/,$/;/e'

        if !s:startsWith('[)\]}]') && !s:startsWith('var')
            call s:prependVar()
        endif
        norm! j
    endif

    return s:convertDeclarationBlock()
endf

fun! s:getCurrentLine()
    return s:strip(getline(line('.')))
endf

fun! s:strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

fun! s:endsWith(string)
    return b:currentLine =~ a:string.'$'
endf

fun! s:startsWith(string)
    return b:currentLine =~ '^'.a:string
endf

fun! s:prependVar()
    norm! ^ivar 
    call s:reindentLine()
endf

fun! s:reindentLine()
    norm! ==
endf

command! SingleToMultiVar call toMultiVar#singleToMultiVar()
