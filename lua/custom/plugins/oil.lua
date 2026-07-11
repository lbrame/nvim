local tabl = {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    columns = {
      'icon',
    },
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}

--- Remember the last oil buffer URL within the current session.
--- Restored when reopening oil via <C-n>.
vim.g.last_oil_dir = nil

local augroup = vim.api.nvim_create_augroup('OilLastDir', { clear = true })

-- Save the oil buffer's URL when leaving it
vim.api.nvim_create_autocmd('BufLeave', {
  group = augroup,
  pattern = 'oil://*',
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname and bufname ~= '' then
      vim.g.last_oil_dir = bufname
    end
  end,
})

-- Open oil at the last-saved directory, falling back to current dir
vim.keymap.set('n', '<C-n>', function()
  if vim.g.last_oil_dir then
    vim.cmd('edit ' .. vim.g.last_oil_dir)
  else
    vim.cmd 'edit .'
  end
end, { desc = 'Open oil.nvim (restores last position)' })

return tabl
