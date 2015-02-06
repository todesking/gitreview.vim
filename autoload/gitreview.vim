" repository root => base commit id
let s:base_commits = {}

function! gitreview#set_base_commit(commit_id, merge_base, path) abort " {{{
	let root = gitreview#util#git_root(a:path)

	if empty(a:commit_id)
		let s:base_commits[root] = ''
		return
	endif

	if a:merge_base
		let resolved_id = gitreview#util#git_merge_base(root, 'HEAD', a:commit_id)
	else
		let resolved_id = gitreview#util#git_merge_base(root, a:commit_id, a:commit_id)
	endif
	let resolved_id = substitute(resolved_id, '\n\+', '', 'g')

	if empty(resolved_id)
		throw 'gitreview#set_base_commit: commit_id invalid: ' . a:commit_id
	endif

	let s:base_commits[root] = resolved_id
endfunction " }}}

function! gitreview#get_base_commit(path, ...) abort " {{{
	let readable = a:0 == 0 ? 0 : a:1
	let root = gitreview#util#git_root(a:path, 0)
	if empty(root)
		return ''
	endif

	let id = get(s:base_commits, root, '')
	if readable
		let id = gitreview#util#git_name_rev(root, id)
	endif
	return id
endfunction " }}}

function! gitreview#changed_files(path) abort " {{{
	let root = gitreview#util#git_root(a:path)

	let base_commit_id = gitreview#get_base_commit(root)
	if empty(base_commit_id)
		return []
	endif
	let files = gitreview#util#git(root, ['diff', '--name-only', base_commit_id . '..HEAD'], 'multiline')
	return files
endfunction " }}}

function! gitreview#in_review(path) abort " {{{
	return !empty(gitreview#get_base_commit(a:path))
endfunction " }}}

function! gitreview#branch_string(path) abort " {{{
	let root = gitreview#util#git_root(a:path, 0)
	let head = gitreview#util#git_head_name(root)
	if len(head)
		let base_commit_id = gitreview#get_base_commit(root, 1)
		if len(base_commit_id)
			let head = base_commit_id . '..' . head
		endif
	endif
	return head
endfunction " }}}
