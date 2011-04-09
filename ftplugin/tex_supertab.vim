" Inspired by ervandew's answer for supertab omnicompletions for perl
" https://github.com/ervandew/supertab/issues/unreads#issue/3
if exists('g:SuperTabCompletionContexts')
    let b:SuperTabCompletionContexts = ['TexContext'] + g:SuperTabCompletionContexts
    function! TexContext()
        let curline = getline('.')
        let cnum = col('.')
        let synname = synIDattr(synID(line('.'), cnum-1, 1), 'name')
        if curline =~ '[{\\]\w*\%' . cnum .'c' && synname !~ '\(String\|Comment\)'
            return "\<c-x>\<c-o>"
        endif
    endfunction
endif

