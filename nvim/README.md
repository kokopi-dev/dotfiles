# Neovim

## Common Commands

Normal Mode:
- `<leader>S` : search and replace with nvim spectre, it checks from your current directory
- `K`: check type
- `<leader>ca` : code action
- `<leader>fg` : live grep from currently dir

## Debugging

- vim print in nvim:
    `lua vim.print(vim.lsp.get_active_clients({name = 'pyright'})[1])`

## Server Setup Schemas
- Go into vim, type :Mason, open a language server with enter, then open it's schema with enter again

## TODO
- figure out better formatting and linting solution
- clean up settings and remap
