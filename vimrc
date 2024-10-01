syntax on 
let mapleader = " "
set clipboard=unnamed
set hls
set is
set cb=unnamed
set gfn=Fixedsys:h13
set ts=2
set expandtab
set sw=2
set si
set rnu
set backspace=indent,eol,start
set ignorecase
set smartcase

" cd D:\OneDrive-CMU\Desktop_Dell\ocom\IPST2024\sandbox

call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'vimsence/vimsence'
call plug#end()

inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>
inoremap {{ {
inoremap {} {}

" compile current cpp file
autocmd filetype cpp nnoremap <F9> :w <bar> !g++ -std=c++17 % -o %:r -Wl,--stack,268435456<CR>

" run current cpp file
autocmd filetype cpp nnoremap <F10> :!%:r<CR>

" compile all cpp files in the same directory
autocmd filetype cpp nnoremap <F11> :w <bar> !g++ -std=c++17 *.cpp -o %:r -Wl,--stack,268435456<CR>

" comment single line
autocmd filetype cpp nnoremap <C-C> :s/^\(\s*\)/\1\/\/<CR> :s/^\(\s*\)\/\/\/\//\1<CR> $

" change directory to current file
autocmd BufEnter * silent! lcd %:p:h

nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprevious<CR>
nnoremap <C-s> :w<CR>

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>


" Rename.vim  -  Rename a buffer within Vim and on the disk
"
" Copyright June 2007-2022 by Christian J. Robinson <heptite@gmail.com>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :Rename[!] {newname}

command! -nargs=1 -complete=file -bang Rename {
		g:Rename(<q-args>, '<bang>')
	}

def g:Rename(name: string, bang: string): bool
	var oldfile = expand('%:p')
	var status: bool

	if bufexists(fnamemodify(name, ':p'))
		if (bang ==# '!')
			silent exe ':' .. bufnr(fnamemodify(name, ':p')) .. 'bwipe!'
		else
			echohl ErrorMsg
			echomsg 'A buffer with that name already exists (use ! to override).'
			echohl None
			return false
		endif
	endif

	status = true

	v:errmsg = ''
	silent! exe 'silent! saveas' .. bang .. ' ' .. name

	if v:errmsg =~# '^$\|^E329'
		var lastbufnr = bufnr('$')

		if expand('%:p') !=# oldfile && filewritable(expand('%:p'))
			if fnamemodify(bufname(lastbufnr), ':p') ==# oldfile
				silent exe ':' .. lastbufnr .. 'bwipe!'
			else
				echohl ErrorMsg
				echomsg 'Could not wipe out the old buffer for some reason.'
				echohl None
				status = false
			endif

			if delete(oldfile) != 0
				echohl ErrorMsg
				echomsg 'Could not delete the old file: ' .. oldfile
				echohl None
				status = false
			endif
		else
			echohl ErrorMsg
			echomsg 'Rename failed for some reason.'
			echohl None
			status = false
		endif
	else
		echoerr v:errmsg
		status = false
	endif

	return status
enddef
