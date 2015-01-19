function! gitreview#util#git(root, args, format) abort " {{{
	if empty(a:root)
		if a:format ==# ''
			return ''
		elseif a:format ==# 'multiline'
			return []
		elseif a:format ==# 'singleline'
			return ''
		endif
		throw 'Illegal format: ' . a:format
	endif

	let command = 'cd ' . shellescape(a:root) . ' && '
	\ . 'git ' . join(map(a:args, 'shellescape(v:val)'), ' ')

	let raw = system(command)
	if a:format ==# ''
		return raw
	elseif a:format ==# 'multiline'
		return split(raw, '\n')
	elseif a:format ==# 'singleline'
		return substitute(raw, '\n\+', '', 'g')
	endif
	throw 'Illegal format: ' . a:format
endfunction " }}}

function! gitreview#util#git_name_rev(root, rev) abort " {{{
	if empty(a:rev)
		return ''
	endif
	return gitreview#util#git(a:root, ['name-rev', '--name-only', a:rev], 'singleline')
endfunction " }}}

function! gitreview#util#git_head_id(root) abort " {{{
	return gitreview#util#git(a:root, ['show', '--pretty=%H', '-s', 'HEAD'], 'singleline')
endfunction " }}}

function! gitreview#util#git_head_name(root) abort " {{{
	return gitreview#util#git_name_rev(a:root, gitreview#util#git_head_id(a:root))
endfunction " }}}

function! gitreview#util#git_merge_base(root, rev1, rev2) abort " {{{
	return gitreview#util#git(a:root, ['merge-base', a:rev1, a:rev2], 'singleline')
endfunction " }}}

function! gitreview#util#git_root(...) abort " {{{
	let path = fnamemodify(a:0 == 0 ? expand('%') : a:1, ':p')
	let throw_on_error = a:0 > 1 ? a:2 : 1

	let dir = isdirectory(path) ? fnamemodify(path, ':p') : fnamemodify(path, ':h')
	let prev = ''

	while dir != prev
		if isdirectory(dir . '/.git')
			return substitute(dir, '/$', '', '')
		endif
		let prev = dir
		let dir = fnamemodify(dir, ':h')
	endwhile
	if throw_on_error
		throw 'Git root not found: ' . path
	else
		return ''
	endif
endfunction " }}}
