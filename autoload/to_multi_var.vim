" ==============================================
" Example on how to map it (also on the README):
" ==============================================

" autocmd FileType js,javascript,javascript.jsx noremap <silent> <Leader>; :call to_multi_var#single_to_multi_var()<CR>

" ------------
" Assumptions:
" - Blocks (functions, object, arrays) should have their openings brackets
"   as the line's last char (line comments are ok)
" - "Comma last" style (commas are at the end of the line instead of in the
"   beggining

let s:debug = 0
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
    let b:count = 0
    while (v:true)
        let b:count = b:count + 1
        if b:count == 10000
            echom 'Iteration limit reached. Aborting.'
            break
        endif
        let b:current_line = s:strip(getline('.'))

        if s:starts_with(b:current_line, '//')
            normal! ==j
            let b:current_line = s:strip(getline('.'))
        endif

        " This whole if block deals with chaining:
        let next_line = s:get_next_real_line()
        if !s:ends_with(getline('.'), '[;,]'.s:optional_line_comment) && s:starts_with(next_line, '\.')
            let prev_line = getline(line('.') - 1)
            if s:starts_with(prev_line, 'var') && s:ends_with(prev_line, ';'.s:optional_line_comment)
                call s:prepend_var()
            endif
            normal! j

            while s:starts_with(getline('.'), '\.')
                normal! ==
                if s:ends_with(getline('.'), s:opening_delimiter_with_optional_line_comment)
                    " Realigns block and go to its ending line:
                    normal! $
                    if s:ends_with(getline('.'), s:line_comment)
                        call search(s:opening_delimiter_with_optional_line_comment, 'bc')
                        normal! =%$
                        call search(s:opening_delimiter_with_optional_line_comment, 'bc')
                    else
                        normal! =%$
                    endif
                    normal! %j
                elseif s:ends_with(getline('.'), ';'.s:optional_line_comment)
                    normal! ==j
                    break
                endif

                if s:ends_with(getline('.'), ','.s:optional_line_comment)
                    exec 's#,'.s:optional_line_comment.'$#;\1#e'
                endif
                normal! ==j
            endwhile
        endif

        let b:current_line = s:strip(getline('.'))

        if s:ends_with(getline('.'), ';'.s:optional_line_comment)
            if !s:starts_with(getline('.'), 'var') && !s:starts_with(getline('.'), s:closing_delimiter)
                call s:prepend_var()
            endif

            break
        endif

        if s:ends_with(getline('.'), s:opening_delimiter_with_optional_line_comment)
            if !s:starts_with(getline('.'), 'var') && !s:starts_with(getline('.'), s:closing_delimiter)
                call s:prepend_var()
            endif

            " Realigns block and go to its ending line:
            normal! $
            if s:ends_with(getline('.'), s:line_comment)
                call search(s:opening_delimiter_with_optional_line_comment, 'bc')
                normal! =%$
                call search(s:opening_delimiter_with_optional_line_comment, 'bc')
            else
                normal! =%$
            endif
            normal! %
        endif

        if s:ends_with(b:current_line, ','.s:optional_line_comment)
            exec 's#,'.s:optional_line_comment.'$#;\1#e'

            if !s:starts_with(b:current_line, s:closing_delimiter) && !s:starts_with(b:current_line, 'var')
                call s:prepend_var()
            endif
            normal! j
        endif
    endwhile
endfunction

function! s:strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:ends_with(line, string)
    return a:line =~ a:string.'$'
endfunction

function! s:starts_with(line, string)
    return s:strip(a:line) =~ '^'.a:string
endfunction

function! s:prepend_var()
    normal! Ivar ==
endfunction

function! s:count_occurences_from_cursor(string)
    let subString = strpart(getline('.'), col('.') - 1)
    return len(split(subString, a:string, 1)) - 1
endfunction

function! s:get_char_under_cursor()
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

function! s:get_token_under_cursor_syntax()
    return synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
endfunction

function! s:get_next_real_line()
    let original_cursor_position = getpos('.')
    normal! j
    let real_line = getline('.')

    while s:ends_with(getline('.'), s:opening_delimiter_with_optional_line_comment)
        normal! $
        if s:ends_with(getline('.'), s:line_comment)
            call search(s:opening_delimiter_with_optional_line_comment, 'bc')
        endif
        normal! %
        let real_line = getline('.')
    endwhile

    call setpos('.', original_cursor_position)

    return real_line
endfunction

function! s:db(string, printLine)
    if (s:debug == 1)
        echon a:string
        if (a:printLine == 1)
            echom '     [prev: '.getline(line('.') - 1)
            echom '     [LINE: '.getline('.')
            echom '     [next: '.getline(line('.') + 1)
        endif
        echom ''
    endif
endfunction

function! to_multi_var#enable_debug_mode()
    let s:debug = 1
    call to_multi_var#single_to_multi_var()
    let s:debug = 0
endfunction

command! SingleToMultiVar call to_multi_var#single_to_multi_var()
command! SingleToMultiVarDebugMode call to_multi_var#enable_debug_mode()
nmap tt :SingleToMultiVarDebugMode<CR>
