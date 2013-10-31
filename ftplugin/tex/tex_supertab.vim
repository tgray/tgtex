" Inspired by ervandew's answer for supertab omnicompletions for perl
" https://github.com/ervandew/supertab/issues/3
if exists('g:SuperTabCompletionContexts')
    let b:SuperTabCompletionContexts = ['TexContext'] + g:SuperTabCompletionContexts
    function! TexContext()
        let curline = getline('.')
        let cnum = col('.')
        let synname = synIDattr(synID(line('.'), cnum-1, 1), 'name')
        if curline =~ '[{\\]\w*\%' . cnum .'c' && synname !~ '\(String\|Comment\)'
            return "\<c-x>\<c-o>"
        elseif curline =~ '\\\includegraphics\S*{$' || curline =~ '\\\input\S*{$' 
            return "\<c-x>\<c-f>"
        endif
    endfunction
endif
" let g:SuperTabDefaultCompletionType = "context"
" 
" function! MyTagContext()
"     let line = getline('.')
"     let pos = col('.')
"     let line_start = line[:pos-1]
"     if line_start =~ '\C\\cite\(p\|t\)\?\*\?\_\s*{\(\S*:*\S*,*\)*\s*' . '$' || line_start =~ '\C\\v\?\(eq\|page\)\?ref\*\?\_\s*{\(\S*:*\S*,*\)*\s*' . '$'
"         return "\<c-x>\<c-o>"
"     elseif line_start =~ '\\\w*$'
"         return "\<c-x>\<c-k>"
"     elseif line_start =~ '\\\includegraphics\S*{$' || line_start =~ '\\\input\S*{$' 
"         return "\<c-x>\<c-f>"
"     endif
"     " no return will result in the evaluation of the next
"     " configured context
" endfunction
" let b:SuperTabCompletionContexts = ['MyTagContext', 's:ContextText']

