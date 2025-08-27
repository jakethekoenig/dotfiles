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
" Force an initial prompt
call chansend(tjob, "\n")
sleep 300m

" First ls with deterministic sort, then ensure a prompt appears
call chansend(tjob, "LC_ALL=C ls -1\n")
sleep 700m
call chansend(tjob, "\n")
sleep 300m

" Second ls, then ensure a prompt appears again
call chansend(tjob, "LC_ALL=C ls -1\n")
sleep 900m
call chansend(tjob, "\n")
sleep 300m

" Jump explicitly to the last printed prompt line
normal! G
let s:last_prompt = search('^\s*\$ \s*$', 'bnW')
call assert_true(s:last_prompt > 0, "Could not find a '$ ' prompt line")
call cursor(s:last_prompt, 1)
" Ensure we are on a prompt line
call assert_true(getline('.') =~# '^\s*\$ \s*$', "Expected to be on '$ ' prompt line")

" Wait until the last line looks like a '$ ' prompt to avoid 'not a prompt' errors
call wait(3000, {-> getline('$') =~# '^\s*\$ \s*$' })

" Ensure output arrived and prompt is visible (basic wait loop)
call wait(3000, {-> getline('$') =~# '^\s*\$ \s*$' })

" 1) Test yanking last output into default register by calling function directly
let before = getpos('.')
call TerminalYankOutput('"')
let after = getpos('.')
call assert_equal(before, after, "Yank should not move the cursor")
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
" Make sure we start from a prompt line
normal! G
call assert_true(getline('.') =~# '^\s*\$ \s*$', "Expected to be on '$ ' prompt line before navigation")
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
