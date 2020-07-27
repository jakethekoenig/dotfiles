" Plugin Ideas:
" * WPM tracker and coach. Could count percent of backspaces or whatever.

let mapleader = "-"
let maplocalleader = "="

" Plugins {{{
"Command to reinstall plugins: PluginInstall
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'honza/vim-snippets'

Plugin 'SirVer/ultisnips'

Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on
" }}}

" Ultisnips {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
" }}}

" Aesthetics {{{
" TODO: Is this the prettiest you can do?
syntax on
set autoindent
set smartindent
set number

set smartcase

set cursorline
set noerrorbells
set title

set dir=~/.vim/.cache

"}}}

" File Type Settings {{{
set spellfile=~/.vim/spell/en.utf-8.add
augroup spell
	autocmd!
	autocmd Filetype tex setlocal spell
	autocmd Filetype html setlocal spell
	autocmd Filetype text setlocal spell
augroup END

" TODO: What other files should I linewrap?
augroup linewrap
	autocmd!
	autocmd Filetype bib setlocal wrap
	autocmd Filetype bib setlocal linewidth=80
augroup END

" This command is really just for editing tex files but it seems harmless to
" make generally available.
onoremap i$ :<c-u>normal! F$lvf$h<cr>
"}}}

" Extending Files {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>es :UltiSnipsEdit<cr>
" }}}

" Insert Mode Commands {{{
inoremap <c-u> <esc>lviwUwi
inoremap jk <esc>
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
"}}}

" Aesthetic Scrolling Changes {{{
nnoremap <c-f> <c-f>zz
nnoremap <c-b> <c-b>zz
nnoremap <c-d> <c-d>zz
nnoremap <c-u> <c-u>zz
"}}}

" Vimscript file settings {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
" }}}

" Livewriting mode {{{
function! ToggleWritingMode()
	if !exists('#WriteMode#InsertLeave')
		augroup WriteMode
			autocmd!
			autocmd InsertLeave * w
		augroup END
	else
		augroup WriteMode
			autocmd!
		augroup END
	endif
endfunction
command! WriteLive call ToggleWritingMode()
" }}}

" Macaulay2 Settings {{{
augroup filetype_mac
	autocmd!
	autocmd Filetype modula2 setlocal syntax=no
augroup END
" }}}

" Commenting Autocommands {{{

" TODO: make this line work for macaulay files
function! IsComment()
	let hg = join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'))
	return hg =~? 'comment' ? 1 : 0
endfunction

augroup comment
	autocmd!
	autocmd FileType python nnoremap <expr> <buffer> <localleader>c IsComment() ? 'mc^x`c' : 'mcI#<esc>`c'
	autocmd FileType modula2 nnoremap <expr> <buffer> <localleader>c IsComment() ? 'mc^xx`c' : 'mcI--<esc>`c'
	autocmd FileType vim nnoremap <expr> <buffer> <localleader>c IsComment() ? 'mc^xx`c' : 'mcI"<space><esc>`c'
	autocmd FileType tex nnoremap <expr> <buffer> <localleader>c IsComment() ? 'mc^xx`c' : 'mcI%<space><esc>`c'
	autocmd FileType html nnoremap <expr> <buffer> <localleader>c IsComment() ? 'mc^5x$4Xx`c' : 'mcI<!--<space><esc>$a<space>--!><esc>`c'
augroup END
" }}}

" Abbreviations {{{

" TODO: handle suffixes? Have toggle to handle which to generate? -v for verb?
function! Abbrevword(...)
	let toabbr = a:1
	let target = join(a:000[1:]," ") 
	execute ("iabbrev " . toabbr ." ".target)
	execute ("iabbrev " . toabbr."s ".target."s")
	execute ("iabbrev " . (toupper(toabbr[0]).toabbr[1:])." ".toupper(target[0]) . target[1:])
	execute ("iabbrev " . (toupper(toabbr[0]).toabbr[1:]."s ".toupper(target[0]).target[1:]."s"))
endfunction
command! -nargs=+ AbbrevWord call Abbrevword(<f-args>)

" Probability
AbbrevWord distr distribution
AbbrevWord disted distributed
AbbrevWord rv random variable
AbbrevWord rV random Variable
AbbrevWord prob probability
AbbrevWord prbs probabilities
AbbrevWord whp with high probability

" Logic (Mathematical bent but not purely
AbbrevWord wlog without loss of generality
AbbrevWord wrt with respect to
AbbrevWord te there exists
AbbrevWord fa for all
AbbrevWord lhs left hand side
AbbrevWord rhs right hand side
AbbrevWord defn definition
AbbrevWord fn function
AbbrevWord cond condition
AbbrevWord st such that
AbbrevWord iff if and only if
AbbrevWord sa such as
AbbrevWord ow otherwise
AbbrevWord resp respectively
AbbrevWord bc because
AbbrevWord wo without

" Linear Algebra
AbbrevWord ind independent
AbbrevWord indy independently
AbbrevWord indc independence
AbbrevWord linind linearly independent
AbbrevWord codim codimension
AbbrevWord cok cokernel
AbbrevWord dmn dimension
AbbrevWord dmnl dimensional

" General Math
AbbrevWord expy exponentially
AbbrevWord clh Cohen-Lenstra heuristic
AbbrevWord cl Cohen-Lenstra
AbbrevWord sst semi-standard Young tableaux
AbbrevWord inj injective
AbbrevWord padic $p$-adic
AbbrevWord poly polynomial
AbbrevWord seq sequence
AbbrevWord ctns continuous


iabbrev ret return
AbbrevWord jmail jakethekoenig@gmail.com
" }}}
