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

function! to_multi_var#single_to_multi_var()
    call s:make_one_declaration_per_line()
    call s:make_one_var_per_declaration()
endfunction

function! s:make_one_declaration_per_line()
    let b:original_cursor_position = getpos('.')

    normal! G$
    while s:has_multiline_var()
        let b:position_before_splitting = getpos('.')

        while search(',\|'.s:opening_delimiter, '', line('.'))
            if s:get_char_under_cursor() =~ s:opening_delimiter
                normal! %
                continue
            endif

            if s:count_occurences_from_cursor(',') == 1
                if getline('.') =~ ';'.s:optional_line_comment.'$'
                    normal! a==^
                else
                    normal! j^
                endif
            elseif s:get_token_under_cursor_syntax() !~ 'String\|Comment\|Constant'
                if s:count_occurences_from_cursor(s:line_comment) == 1
                    normal! l
                    if s:count_occurences_from_cursor(',.*'.s:line_comment) > 0
                        normal! ha==^
                    endif
                else
                    normal! a==^
                endif
            endif
        endwhile

        call setpos('.', b:position_before_splitting)
    endwhile

    call setpos('.', b:original_cursor_position)
endfunction

function! s:make_one_var_per_declaration()
    let b:original_cursor_position = getpos('.')

    normal! G
    while s:has_multiline_var()
        call s:convert_declaration_block()
    endwhile

    call setpos('.', b:original_cursor_position)
endfunction

function! s:has_multiline_var()
    return search('^\s*var.\+,\(.*;\)\?'.s:optional_line_comment.'$', 'bW') > 0
endfunction

" The real magic:
function! s:convert_declaration_block()
    let b:current_line = s:get_current_line()

    if s:starts_with('//')
        normal! ==j
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

function! s:get_current_line()
    return s:strip(getline('.'))
endfunction

function! s:strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:ends_with(string)
    return b:current_line =~ a:string.'$'
endfunction

function! s:starts_with(string)
    return b:current_line =~ '^'.a:string
endfunction

function! s:prepend_var()
    normal! Ivar ==
endfunction

function! s:count_occurences_from_cursor(string)
    let subString = strpart(getline('.'), col('.')-1)
    return len(split(subString, a:string, 1)) - 1
endfunction

function! s:get_char_under_cursor()
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

function! s:get_token_under_cursor_syntax()
    return synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
endfunction

command! SingleToMultiVar call to_multi_var#single_to_multi_var()
