" Headless test for TerminalYankOutput and prompt navigation
let s:tmpdir = getcwd() . '/test/tmpdir'
call mkdir(s:tmpdir, 'p')
call writefile(['alpha', 'beta', 'gamma'], s:tmpdir . '/alpha')
call writefile(['x', 'y'], s:tmpdir . '/beta')
call writefile([], s:tmpdir . '/gamma')

" Open a terminal
terminal
" Ensure we're in normal mode
stopinsert

" Get terminal job id
let tjob = b:terminal_job_id

" Change to repo root to have predictable ls target
call chansend(tjob, "cd " . fnameescape(s:tmpdir) . "\n")

" Run ls twice with -1 for stable single-column output
call chansend(tjob, "ls -1\n")
" Give time for output
sleep 200m
call chansend(tjob, "ls -1\n")
sleep 200m

" Move cursor to last line (should be current prompt)
normal! G

" 1) Test <leader>yo yanks last output into default register
" Use unnamed register
execute "normal! \\<leader>yo"
let got = getreg('"')
" Expected is the lines between the two last prompts, i.e., output of the second ls
" It should be a permutation depending on locale, but ls -1 is lexical; our files: alpha beta gamma
let expected = "alpha\nbeta\ngamma\n"
call assert_equal(expected, got, "Yanked output should equal second ls output")

" 2) Test register use: \"a<leader>yo puts into register a
execute "normal! \"a\\<leader>yo"
let got_a = getreg('a')
call assert_equal(expected, got_a, "Register a should receive yanked output")

" 3) Test navigation: <leader>k goes to previous prompt, <leader>j returns to next/current
let curr = line('.')
" Go to previous prompt
execute "normal! \\<leader>k"
let prev = line('.')
call assert_true(prev < curr, "Prev prompt should be above current")
" And go forward
execute "normal! \\<leader>j"
let curr2 = line('.')
call assert_equal(curr, curr2, "Next prompt should return to current prompt")

" If we reached here, all assertions passed
cquit
