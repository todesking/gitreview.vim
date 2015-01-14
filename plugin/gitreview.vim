" Primary functions {{{
command! -nargs=1 GitReviewStart call gitreview#set_base_commit(<f-args>, 1, expand('%'))
command! -nargs=0 GitReviewEnd call gitreview#set_base_commit('', 0), expand('%')
" }}}

" Unite source {{{
if gitreview#unite#available()
	let s:unite_source = {'name': 'gitreview/changed_files'}
	function! s:unite_source.gather_candidates(args, context)
		let root = gitreview#util#git_root()
		return map(gitreview#changed_files(root), '{
			\ "word": v:val,
			\ "source": "gitreview/changed_files",
			\ "kind": "file",
			\ "action__path": root . "/" . v:val,
			\ }')
	endfunction
	call unite#define_source(s:unite_source)
	unlet s:unite_source
endif
" }}}

" Fugitive integration {{{
if gitreview#fugitive#available()
	command! -nargs=0 GitReviewDiff call gitreview#fugitive#diff_command()
endif
" }}}

" GitGutter integration {{{
if gitreview#gitgutter#available()
	command! GitGutterAll call gitreview#gitgutter#all()
	command! GitGutter    call gitreview#gitgutter#process_buffer(bufnr(''), 0)

	augroup gitgutter
	  autocmd!
	augroup END

	augroup gitreview-gitgutter
	  autocmd!
	  if g:gitgutter_realtime
	  autocmd CursorHold,CursorHoldI * call gitreview#gitgutter#process_buffer(bufnr(''), 1)
	  endif

	  if g:gitgutter_eager
		autocmd BufEnter,BufWritePost,FileChangedShellPost *
			  \  if gettabvar(tabpagenr(), 'gitgutter_didtabenter') |
			  \   call settabvar(tabpagenr(), 'gitgutter_didtabenter', 0) |
			  \ else |
			  \   call gitreview#gitgutter#process_buffer(bufnr(''), 0) |
			  \ endif
		autocmd TabEnter *
			  \  call settabvar(tabpagenr(), 'gitgutter_didtabenter', 1) |
			  \ call gitreview#gitgutter#all()
		if !has('gui_win32')
		  autocmd FocusGained * call gitreview#gitgutter#all()
		endif
	  else
		autocmd BufRead,BufWritePost,FileChangedShellPost * call gitreview#gitgutter#process_buffer(bufnr(''), 0)
	  endif

	  autocmd ColorScheme * call gitgutter#highlight#define_sign_column_highlight() | call gitgutter#highlight#define_highlights()

	  " Disable during :vimgrep
	  autocmd QuickFixCmdPre  *vimgrep* let g:gitgutter_enabled = 0
	  autocmd QuickFixCmdPost *vimgrep* let g:gitgutter_enabled = 1
	augroup END
endif
" }}}
