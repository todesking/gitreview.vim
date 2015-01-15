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

function! gitreview#fugitive#branch_string() abort " {{{
	let head = fugitive#head()
	if len(head)
		let base_commit_id = gitreview#get_base_commit(expand('%'), 1)
		if len(base_commit_id)
			let head = base_commit_id . '..' . head
		endif
	endif
	return head
endfunction " }}}
