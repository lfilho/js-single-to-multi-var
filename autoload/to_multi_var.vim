" ==============================================
" Example on how to map it (also on the README):
" ==============================================

" autocmd FileType js,javascript,javascript.jsx noremap <silent> <Leader>; :call to_multi_var#singleToMultiVar()<CR>

" ------------
" Assumptions:
" - One variable per line
" - Blocks (functions, object, arrays) should have their openings brackets
"   as the line's last char (line comments are ok)
" - "Comma last" style (commas are at the end of the line instead of in the
"   beggining

let s:lineComment = '\(\s*\/\/.*\)'
let s:optionalLineComment = s:lineComment.'\?'
let s:closingDelimiter = '[)\]}]'
let s:openingDelimiter = '[(\[{]'
let s:openingDelimiterWithOptionalLineComment = s:openingDelimiter . s:optionalLineComment

fun! to_multi_var#singleToMultiVar()
    let b:originalCursorPosition = getpos('.')

    norm! G
    while s:hasMultilineVar()
        call s:convertDeclarationBlock()
    endwhile

    call setpos('.', b:originalCursorPosition)
endfun

fun! s:hasMultilineVar()
    return search('^\s*var.\+,'.s:optionalLineComment.'$', 'bW') > 0
endf

" The real magic:
fun! s:convertDeclarationBlock()
    let b:currentLine = s:getCurrentLine()

    if s:startsWith('//')
        call s:reindentLine()
        norm! j
        let b:currentLine = s:getCurrentLine()
    endif

    if s:endsWith(';'.s:optionalLineComment)
        if !s:startsWith('var') && !s:startsWith(s:closingDelimiter)
            call s:prependVar()
        endif

        return
    endif

    if s:endsWith(s:openingDelimiterWithOptionalLineComment)
        if !s:startsWith('var') && !s:startsWith(s:closingDelimiter)
            call s:prependVar()
        endif

        " Realigns block and go to its ending line:
        norm! $
        if s:endsWith(s:lineComment)
            call search(s:openingDelimiterWithOptionalLineComment, 'bc')
            norm! =%$
            call search(s:openingDelimiterWithOptionalLineComment, 'bc')
        else
            norm! =%$
        endif
        norm! %
    endif

    if s:endsWith(','.s:optionalLineComment)
        exec 's#,'.s:optionalLineComment.'$#;\1#e'

        if !s:startsWith(s:closingDelimiter) && !s:startsWith('var')
            call s:prependVar()
        endif
        norm! j
    endif

    return s:convertDeclarationBlock()
endf

fun! s:getCurrentLine()
    return s:strip(getline('.'))
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
    norm! Ivar 
    call s:reindentLine()
endf

fun! s:reindentLine()
    norm! ==
endf

command! SingleToMultiVar call to_multi_var#singleToMultiVar()
