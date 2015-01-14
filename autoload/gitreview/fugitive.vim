function! gitreview#fugitive#available() abort " {{{
	return exists('g:loaded_fugitive') && g:loaded_fugitive
endfunction " }}}

function! gitreview#fugitive#diff_command() abort " {{{
	let base_commit_id = gitreview#get_base_commit(expand('%'))
	if empty(base_commit_id)
		echoerr 'gitreview.vim: base commit not set'
		return
	endif
	execute 'Gdiff ' . base_commit_id
endfunction " }}}
