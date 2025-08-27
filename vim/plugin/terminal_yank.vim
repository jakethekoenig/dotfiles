" Terminal prompt utilities and yank-output for terminal buffers

if exists('g:loaded_terminal_yank')
  finish
endif
let g:loaded_terminal_yank = 1

function! s:IsTerminalBuffer() abort
  return &buftype ==# 'terminal'
endfunction

" Extract the prompt token from the current line: leading non-space up to first whitespace
function! TerminalPromptToken() abort
  let l:line = getline('.')
  let l:token = matchstr(l:line, '^\s*\zs\S\+')
  return l:token
endfunction

function! s:PromptRegexFromToken(token) abort
  " Build regex to match start of line + optional spaces + token + (whitespace or EOL)
  let l:tok = escape(a:token, '\.^$~[]*(){}|?+-')
  return '^\s*' . l:tok . '\(\s\|$\)'
endfunction

" Move cursor to previous prompt line matching the current line's token
function! TerminalGotoPrevPrompt() abort
  if !s:IsTerminalBuffer()
    echo "Not a terminal buffer"
    return
  endif
  let l:token = TerminalPromptToken()
  if empty(l:token)
    echo "No prompt token on this line"
    return
  endif
  let l:base = s:PromptRegexFromToken(l:token)
  " Exclude the current line using \%<Nl (match only on lines strictly above)
  let l:pat = '\%<' . line('.') . 'l' . l:base
  let l:lnum = search(l:pat, 'bnW')
  if l:lnum > 0
    call cursor(l:lnum, 1)
  else
    echo "No previous prompt found"
  endif
endfunction

" Move cursor to next prompt line matching the current line's token
function! TerminalGotoNextPrompt() abort
  if !s:IsTerminalBuffer()
    echo "Not a terminal buffer"
    return
  endif
  let l:token = TerminalPromptToken()
  if empty(l:token)
    echo "No prompt token on this line"
    return
  endif
  let l:base = s:PromptRegexFromToken(l:token)
  " Exclude the current line using \%>Nl (match only on lines strictly below)
  let l:pat = '\%>' . line('.') . 'l' . l:base
  let l:lnum = search(l:pat, 'W')
  if l:lnum > 0
    call cursor(l:lnum, 1)
  else
    echo "No next prompt found"
  endif
endfunction

" Yank the output block immediately preceding the current prompt line.
" Does not move the cursor. Respects the provided register.
" Special case: if the current prompt starts with '╰─$' then drop the last line
" of the captured output (to account for two-line PS1).
function! TerminalYankOutput(reg) abort
  if !s:IsTerminalBuffer()
    echo "Not a terminal buffer"
    return
  endif

  let l:curr_line = getline('.')
  let l:token = TerminalPromptToken()
  if empty(l:token)
    echo "Current line does not look like a prompt"
    return
  endif

  " Verify current line matches the token at start (i.e., we are on a prompt)
  let l:pat = s:PromptRegexFromToken(l:token)
  if match(l:curr_line, l:pat) != 0
    echo "Place cursor on a prompt line to yank output"
    return
  endif

  " Find the previous prompt without moving the cursor and exclude current line
  let l:savepos = getpos('.')
  let l:base = s:PromptRegexFromToken(l:token)
  let l:pat_prev = '\%<' . l:savepos[1] . 'l' . l:base
  " 'n' flag: do not move the cursor
  let l:prev_prompt = search(l:pat_prev, 'bnWn')
  let l:start_line = (l:prev_prompt > 0) ? (l:prev_prompt + 1) : 1
  let l:end_line = l:savepos[1] - 1

  if l:end_line < l:start_line
    " No output between prompts
    call setreg(a:reg, '', 'l')
    echo "No output to yank"
    return
  endif

  let l:lines = getline(l:start_line, l:end_line)

  " Special handling for two-line prompt where the lower line starts with '╰─$' (allow optional space)
  if l:curr_line =~# '^\s*╰─\s*\$'
    if len(l:lines) > 0
      call remove(l:lines, -1)
    endif
  endif

  " Set as linewise register to preserve line boundaries
  call setreg(a:reg, l:lines, 'l')
  echo "Yanked " . len(l:lines) . " line(s) to register " . (empty(a:reg) ? '"' : a:reg)
endfunction
