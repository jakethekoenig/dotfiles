setlocal foldmethod=marker

augroup source
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
