# gitreview.vim: To help your code review in git repository

## Basic commands

* `GitReviewStart <base_commit>`
  * Set `base_commit`
* `GitReviewEnd`
  * Unset `base_commit`


## Diff command

Dependency: [Fugitive](https://github.com/tpope/vim-fugitive)

* `GitReviewDiff`
  * Show diff of `base_commit..HEAD`

## Statusline string

* `gitreview#branch_string(current_file_path)`
  * returns `'<base_commit_id>..<current_branch_name>'`
  * example: `set statusline = '... %{gitreview#branch_string(expand("%"))} ...'`

## Unite source

Dependency: [Unite.vim](https://github.com/Shougo/unite.vim)

* `Unite gitreview/changed_files`
  * List changed files since `base_commit`


## Gitgutter integration

Dependency: [Gitgutter](https://github.com/airblade/vim-gitgutter)

If Gitgutter installed, sign represents changed lines since `base_commit`.

Some key map is provided:

* `<Plug>(gitreview-gitgutter-next-sign)`
  * Jump to next sign in same file
* `<Plug>(gitreview-gitgutter-prev-sign)`
  * Jump to previous sign in same file
