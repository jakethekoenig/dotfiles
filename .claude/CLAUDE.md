# NeoVim Integration

User runs Claude inside NeoVim's `:terminal` with `nvim --listen /tmp/nvim.sock`.
- Use `--clean --remote` or `--clean --remote-expr "execute('...')"` to control the editor (--clean avoids loading user config and is much faster)
- Do NOT use `--remote-send` — keystrokes get misrouted into the terminal buffer
- User needs to be in normal mode (not terminal mode) for socket commands to work, but RPC commands are more reliable than keystroke simulation
