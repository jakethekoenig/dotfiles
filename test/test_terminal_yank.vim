" Headless test for TerminalYankOutput and prompt navigation
let s:tmpdir = getcwd() . '/test/tmpdir'
call mkdir(s:tmpdir, 'p')
call writefile(['alpha', 'beta', 'gamma'], s:tmpdir . '/alpha')
call writefile(['x', 'y'], s:tmpdir . '/beta')
call writefile([], s:tmpdir . '/gamma')

" Open a terminal with an interactive bash and controlled prompt
terminal bash --norc --noprofile -i
" Ensure we're in normal mode
stopinsert

" Get terminal job id
let tjob = b:terminal_job_id

" Set a simple single-line prompt and cd to our tmpdir
call chansend(tjob, "export PS1='$ '\n")
call chansend(tjob, "cd " . fnameescape(s:tmpdir) . "\n")

" Run ls twice with deterministic sort order
call chansend(tjob, "LC_ALL=C ls -1\n")
" Give time for output
sleep 600m
call chansend(tjob, "LC_ALL=C ls -1\n")
sleep 900m

" Move cursor to last line (should be current prompt)
normal! G

" Wait until the last line looks like a '$ ' prompt to avoid 'not a prompt' errors
call wait(3000, {-> getline('$') =~# '^\s*\$ \s*$' })

" Ensure output arrived (basic wait loop)
call wait(2000, {-> line('$') >= 1 })

" 1) Test yanking last output into default register by calling function directly
call TerminalYankOutput('"')
let got = getreg('"')
" Expected is the lines between the two last prompts, i.e., output of the second ls
" It should be a permutation depending on locale, but ls -1 is lexical; our files: alpha beta gamma
let expected = "alpha\nbeta\ngamma\n"
call assert_equal(expected, got, "Yanked output should equal second ls output")

" 2) Test register use: put into register a
call TerminalYankOutput('a')
let got_a = getreg('a')
call assert_equal(expected, got_a, "Register a should receive yanked output")

" 3) Test navigation: <leader>k goes to previous prompt, <leader>j returns to next/current
let curr = line('.')
" Go to previous prompt
call TerminalGotoPrevPrompt()
let prev = line('.')
call assert_true(prev < curr, "Prev prompt should be above current")
" And go forward
call TerminalGotoNextPrompt()
let curr2 = line('.')
call assert_equal(curr, curr2, "Next prompt should return to current prompt")

" Exit status based on assertions
if len(v:errors) > 0
  cquit
else
  quit
endif
