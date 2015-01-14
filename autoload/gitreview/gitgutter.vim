function! gitreview#gitgutter#available() abort " {{{
	return exists('g:loaded_gitgutter') && g:loaded_gitgutter
endfunction " }}}

function! gitreview#gitgutter#process_buffer(bufnr, realtime) abort " {{{
	let path = expand('#' . a:bufnr . ':p')
	let base_commit_id = gitreview#get_base_commit(path)
	if !empty(base_commit_id)
		let old = g:gitgutter_diff_args

		let g:gitgutter_diff_args .= ' ' . base_commit_id . '..HEAD '
		call gitgutter#process_buffer(a:bufnr, a:realtime)

		let g:gitgutter_diff_args = old
	else
		call gitgutter#process_buffer(a:bufnr, a:realtime)
	endif
endfunction " }}}

function! gitreview#gitgutter#all() abort " {{{
  for buffer_id in tabpagebuflist()
    let file = expand('#' . buffer_id . ':p')
    if !empty(file)
      call gitreview#gitgutter#process_buffer(buffer_id, 0)
    endif
  endfor
endfunction " }}}
