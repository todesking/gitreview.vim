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

function!  gitreview#gitgutter#signs() abort " {{{
	call gitgutter#sign#find_current_signs()
	return b:gitgutter_gitgutter_signs
endfunction " }}}

function! gitreview#gitgutter#next_sign_line_number(prev) abort " {{{
	let signs = gitreview#gitgutter#signs()
	let line = getpos('.')[1]
	let sorted = []
	for l in keys(signs)
		let data = copy(signs[l])
		let data.line_number = l
		call add(sorted, data)
	endfor
	call sort(sorted, function('s:sort_by_line_number'))

	if a:prev
		call reverse(sorted)
	endif

	for sign in sorted
		if (a:prev && sign.line_number < line) || (!a:prev && sign.line_number > line)
			return sign.line_number
		endif
	endfor
	return 0
endfunction " }}}

function! s:sort_by_line_number(l, r) abort " {{{
	return a:l.line_number - a:r.line_number
endfunction " }}}

function! gitreview#gitgutter#jump_to_next_sign() abort " {{{
	 call s:set_line(gitreview#gitgutter#next_sign_line_number(0))
endfunction " }}}

function! gitreview#gitgutter#jump_to_prev_sign() abort " {{{
	 call s:set_line(gitreview#gitgutter#next_sign_line_number(1))
endfunction " }}}

function! s:set_line(line) abort " {{{
	if a:line <= 0
		return
	endif
	let pos = getpos('.')
	let pos[1:2] = [a:line, 0]
	call setpos('.', pos)
endfunction " }}}
