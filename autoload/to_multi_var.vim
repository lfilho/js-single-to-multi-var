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

function! to_multi_var#singleToMultiVar() abort
    let b:original_cursor_position = getpos('.')

    normal! G
    while s:hasMultilineVar()
        call s:convertDeclarationBlock()
    endwhile

    call setpos('.', b:original_cursor_position)
endfunction

function! s:hasMultilineVar() abort
    return search('^\s*var.\+,'.s:optional_line_comment.'$', 'bW') > 0
endfunction

" The real magic:
function! s:convertDeclarationBlock() abort
    let b:current_line = s:getCurrentLine()

    if s:startsWith('//')
        call s:reindentLine()
        normal! j
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
        normal! $
        if s:endsWith(s:line_comment)
            call search(s:opening_delimiter_with_optional_line_comment, 'bc')
            normal! =%$
            call search(s:opening_delimiter_with_optional_line_comment, 'bc')
        else
            normal! =%$
        endif
        normal! %
    endif

    if s:endsWith(','.s:optional_line_comment)
        exec 's#,'.s:optional_line_comment.'$#;\1#e'

        if !s:startsWith(s:closing_delimiter) && !s:startsWith('var')
            call s:prependVar()
        endif
        normal! j
    endif

    return s:convertDeclarationBlock()
endfunction

function! s:getCurrentLine() abort
    return s:strip(getline('.'))
endfunction

function! s:strip(string) abort
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:endsWith(string) abort
    return b:current_line =~ a:string.'$'
endfunction

function! s:startsWith(string) abort
    return b:current_line =~ '^'.a:string
endfunction

function! s:prependVar() abort
    normal! Ivar 
    call s:reindentLine()
endfunction

function! s:reindentLine() abort
    normal! ==
endfunction

command! SingleToMultiVar call to_multi_var#singleToMultiVar()
