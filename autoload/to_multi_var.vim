" ==============================================
" Example on how to map it (also on the README):
" ==============================================

" autocmd FileType js,javascript,javascript.jsx noremap <silent> <Leader>; :call to_multi_var#single_to_multi_var()<CR>

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

function! to_multi_var#single_to_multi_var() abort
    let b:original_cursor_position = getpos('.')

    normal! G
    while s:has_multiline_var()
        call s:convert_declaration_block()
    endwhile

    call setpos('.', b:original_cursor_position)
endfunction

function! s:has_multiline_var() abort
    return search('^\s*var.\+,'.s:optional_line_comment.'$', 'bW') > 0
endfunction

" The real magic:
function! s:convert_declaration_block() abort
    let b:current_line = s:get_current_line()

    if s:starts_with('//')
        call s:reindent_line()
        normal! j
        let b:current_line = s:get_current_line()
    endif

    if s:ends_with(';'.s:optional_line_comment)
        if !s:starts_with('var') && !s:starts_with(s:closing_delimiter)
            call s:prepend_var()
        endif

        return
    endif

    if s:ends_with(s:opening_delimiter_with_optional_line_comment)
        if !s:starts_with('var') && !s:starts_with(s:closing_delimiter)
            call s:prepend_var()
        endif

        " Realigns block and go to its ending line:
        normal! $
        if s:ends_with(s:line_comment)
            call search(s:opening_delimiter_with_optional_line_comment, 'bc')
            normal! =%$
            call search(s:opening_delimiter_with_optional_line_comment, 'bc')
        else
            normal! =%$
        endif
        normal! %
    endif

    if s:ends_with(','.s:optional_line_comment)
        exec 's#,'.s:optional_line_comment.'$#;\1#e'

        if !s:starts_with(s:closing_delimiter) && !s:starts_with('var')
            call s:prepend_var()
        endif
        normal! j
    endif

    return s:convert_declaration_block()
endfunction

function! s:get_current_line() abort
    return s:strip(getline('.'))
endfunction

function! s:strip(string) abort
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:ends_with(string) abort
    return b:current_line =~ a:string.'$'
endfunction

function! s:starts_with(string) abort
    return b:current_line =~ '^'.a:string
endfunction

function! s:prepend_var() abort
    normal! Ivar 
    call s:reindent_line()
endfunction

function! s:reindent_line() abort
    normal! ==
endfunction

command! SingleToMultiVar call to_multi_var#single_to_multi_var()
