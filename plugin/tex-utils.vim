command! MakeTex call <SID>compile_tex()
command! MakeLuaTex call <SID>compile_luatex()
command! ViewTex call <SID>view_output()
command! ViewLog call <SID>view_log()
command! MakeBib call <SID>bibtex_tex()
"command! TexRoot call <SID>get_tex_root()
autocmd QuickFixCmdPost * :cw 

"nunmap <Leader>t
nmap <buffer> <Leader>tt :MakeTex<CR>
nmap <buffer> <Leader>to :ViewTex<CR>
nmap <buffer> <Leader>tl :ViewLog<CR>
nmap <buffer> <Leader>tu :MakeLuaTex<CR>
nmap <buffer> <Leader>tb :MakeBib<CR>

map <Leader>ts :up<CR>:silent !/Applications/Skim.app/Contents/SharedSupport/displayline <C-r>=line('.')<CR> %<.pdf %<CR>

if !exists('g:tex_flavor')
	let g:tex_flavor = 'pdflatex'
endif

" get_tex_root is loosely based on code from from Kevin C. Klement
" klement <at> philos <dot> umass <dot> edu
" http://www.charlietanksley.net/philtex/vim-live-latex-preview/
function! s:get_tex_root()
    let b:root_tex = expand("%")
	let this_dir = expand("%:p:h")
    for linenum in range(1,5)
        let linecontents = getline(linenum)
        if linecontents =~ '%\s*!TEX\sroot\s*='
			let root_tex_rel = substitute(linecontents, '.*root\s*=\s*', "", "")
			let root_tex_rel = substitute(root_tex_rel, '\s*$', "", "")
			let b:root_tex = simplify(this_dir.'/'.root_tex_rel)
        endif
		let b:root_dir = fnamemodify(b:root_tex, ":h")
		let b:root_pdf = fnamemodify(b:root_tex, ":r").".pdf"
		let b:root_log = fnamemodify(b:root_tex, ":r").".log"
        let b:tex_filename = fnamemodify(b:root_tex, ":t")
    endfor
endfunction

function! s:compile_tex()
	call s:get_tex_root()
	if exists('g:tex_flavor')
		compiler tex
		let &makeprg=g:tex_flavor." -file-line-error -interaction=nonstopmode -synctex=1 --output-format=pdf"
		let &errorformat="%f:%l: %m"
		let oldpath = getcwd()
		if filereadable(b:root_tex)
            :up
			exec 'lcd '.b:root_dir
			silent exec 'make '.b:tex_filename
			exec 'lcd '.oldpath
			echom g:tex_flavor " finished."
		else
			echoerr b:root_tex "is not a readable file."
		endif
	endif
endfunction

function! s:compile_luatex()
	let old_tex_flavor = g:tex_flavor
	let g:tex_flavor = 'lualatex'
	call s:compile_tex()
	let g:tex_flavor = old_tex_flavor 
endfunction


function! s:bibtex_tex()
    call s:get_tex_root()
    let oldpath = getcwd()
    if filereadable(b:root_tex)
        :up
        exec 'lcd '.b:root_dir
        silent exec '!bibtex '.fnamemodify(b:tex_filename, ":r")
        exec 'lcd '.oldpath
        echom "bibtex finished."
    else
        echoerr b:root_tex "is not a readable file."
    endif
endfunction

function! s:view_output()
	call s:get_tex_root()
	if filereadable(b:root_pdf)
		silent exec '!open -a "Skim" '.b:root_pdf
	else
		echoerr b:root_pdf "is not a readable file."
	endif
endfunction

function! s:view_log()
	call s:get_tex_root()
	if filereadable(b:root_log)
		exec 'sview '.b:root_log
	else
		echoerr b:root_log "is not a readable file."
	endif
endfunction

