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

let s:line_comment = '\(\s*\/\/.*\)'
let s:optional_line_comment = s:line_comment.'\?'
let s:closing_delimiter = '[)\]}]'
let s:opening_delimiter = '[(\[{]'
let s:opening_delimiter_with_optional_line_comment = s:opening_delimiter . s:optional_line_comment

fun! to_multi_var#singleToMultiVar()
    let b:original_cursor_position = getpos('.')

    norm! G
    while s:hasMultilineVar()
        call s:convertDeclarationBlock()
    endwhile

    call setpos('.', b:original_cursor_position)
endfun

fun! s:hasMultilineVar()
    return search('^\s*var.\+,'.s:optional_line_comment.'$', 'bW') > 0
endf

" The real magic:
fun! s:convertDeclarationBlock()
    let b:current_line = s:getCurrentLine()

    if s:startsWith('//')
        call s:reindentLine()
        norm! j
        let b:current_line = s:getCurrentLine()
    endif

    if s:endsWith(';'.s:optional_line_comment)
        if !s:startsWith('var') && !s:startsWith(s:closing_delimiter)
            call s:prependVar()
        endif

        return
    endif

    if s:endsWith(s:opening_delimiter_with_optional_line_comment)
        if !s:startsWith('var') && !s:startsWith(s:closing_delimiter)
            call s:prependVar()
        endif

        " Realigns block and go to its ending line:
        norm! $
        if s:endsWith(s:line_comment)
            call search(s:opening_delimiter_with_optional_line_comment, 'bc')
            norm! =%$
            call search(s:opening_delimiter_with_optional_line_comment, 'bc')
        else
            norm! =%$
        endif
        norm! %
    endif

    if s:endsWith(','.s:optional_line_comment)
        exec 's#,'.s:optional_line_comment.'$#;\1#e'

        if !s:startsWith(s:closing_delimiter) && !s:startsWith('var')
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
    return b:current_line =~ a:string.'$'
endf

fun! s:startsWith(string)
    return b:current_line =~ '^'.a:string
endf

fun! s:prependVar()
    norm! Ivar 
    call s:reindentLine()
endf

fun! s:reindentLine()
    norm! ==
endf

command! SingleToMultiVar call to_multi_var#singleToMultiVar()
