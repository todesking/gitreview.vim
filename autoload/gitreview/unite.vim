function! gitreview#unite#available() abort " {{{
	return exists('g:loaded_unite') && g:loaded_unite
endfunction " }}}
