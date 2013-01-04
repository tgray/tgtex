" Language:	latex, tex
" Maintainer:	Johannes Zellner <johannes@zellner.org>
" URL:		http://www.zellner.org/vim/fold/tex.vim
" Last Change:	Son, 01 Apr 2001 06:16:53 +0200
" $Id: tex.vim,v 1.3 2001/04/03 03:57:33 joze Exp $

""finish

setlocal foldexpr=TexFold(v:lnum)
setlocal foldmethod=expr

" " [-- avoid multiple sourcing --]
" if exists("*TexFold")
"     setlocal foldmethod=expr
"     finish
" endif
" 

fun! TexFoldContextWithDepth(line)
    if a:line =~ '\\part\>'			| return 1
    elseif a:line =~ '\\chapter\>'		| return 2
    elseif a:line =~ '\\section\>'		| return 3
    elseif a:line =~ '\\subsection\>'		| return 4
    elseif a:line =~ '\\subsubsection\>'	| return 5
    elseif a:line =~ '\\paragraph\>'		| return 6
    elseif a:line =~ '\\subparagraph\>'		| return 7
    else					| return 0
    endif
endfun

fun! TexFoldContextFlat(line)
    if a:line =~ '\\\(part\|chapter\|\(sub\)\+section\|\(sub\)\=paragraph\)\>'
	return 1
    else
	return 0
    endif
endfun

fun! TexFold(lnum)
    " remove comments
    let line = substitute(getline(a:lnum), '\(^%\|\s*[^\\]%\).*$', '', 'g')
    " let level = TexFoldContextFlat(line)
      let level = TexFoldContextWithDepth(line)
    if level
	exe 'return ">'.level.'"'
    elseif line =~ '.*\\begin\>.*'
	return 'a1'
    elseif line =~ '.*\\end\>.*'
	return 's1'
    else
	return '='
    endif
endfun

" vim:ts=8
