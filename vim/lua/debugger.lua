
require('dap-python').setup('python3')

vim.keymap.set('n', '<leader>1', require('dap').toggle_breakpoint)
vim.keymap.set('n', '<leader>2', require('dap').continue)
vim.keymap.set('n', '<leader>3', require('dap').step_over)
vim.keymap.set('n', '<leader>4', require('dap').step_into)
