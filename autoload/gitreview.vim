" repository root => base commit id
let s:base_commits = {}

function! gitreview#set_base_commit(commit_id, merge_base, path) abort " {{{
	let root = gitreview#util#git_root(a:path)

	if a:merge_base
		let resolved_id = gitreview#util#git(root, ['merge-base', 'HEAD', a:commit_id])
	else
		let resolved_id = gitreview#util#git(root, ['merge-base', a:commit_id, a:commit_id])
	endif
	let resolved_id = substitute(resolved_id, '\n\+', '', 'g')

	if empty(resolved_id)
		throw 'gitreview#set_base_commit: commit_id invalid: ' . a:commit_id
	endif

	let s:base_commits[root] = resolved_id
endfunction " }}}

function! gitreview#get_base_commit(path) abort " {{{
	let root = gitreview#util#git_root(a:path, 0)
	if empty(root)
		return ''
	endif

	let id = get(s:base_commits, root, '')
	return id
endfunction " }}}

function! gitreview#changed_files(path) abort " {{{
	let root = gitreview#util#git_root(a:path)

	let base_commit_id = gitreview#get_base_commit(root)
	if empty(base_commit_id)
		return []
	endif
	let files = split(gitreview#util#git(root, ['diff', '--name-only', base_commit_id . '..HEAD']), "\n")
	return files
endfunction " }}}

function! gitreview#in_review(path) abort " {{{
	return !empty(gitreview#get_base_commit(a:path))
endfunction " }}}
