function! gitreview#util#git(root, args) abort " {{{
	let command = 'cd ' . shellescape(a:root) . ' && '
	\ . 'git ' . join(map(a:args, 'shellescape(v:val)'), ' ')

	return system(command)
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
