local indent_widths = {
  lua = 3,
  python = 4,
  go = 4,
  javascript = 2,
  javascriptreact = 2,
  typescript = 2,
  typescriptreact = 2,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(indent_widths),
  callback = function(args)
    local width = indent_widths[args.match]
    vim.bo[args.buf].shiftwidth = width
    vim.bo[args.buf].tabstop = width
    vim.bo[args.buf].softtabstop = width
    vim.bo[args.buf].expandtab = true
    vim.bo[args.buf].autoindent = true
  end,
})

vim.api.nvim_exec([[
  autocmd TermOpen * setlocal scrollback=5000
]], false)

-- Group for auto-reloading
local reload_group = vim.api.nvim_create_augroup('NvimConfigReload', { clear = true })

-- Watch all .lua files in the config directory
local config_path = vim.fn.stdpath('config') .. '/**/*.lua'

vim.api.nvim_create_autocmd('BufWritePost', {
  group = reload_group,
  pattern = config_path,
  callback = function()
    -- Reload the entire config by sourcing init.lua
    vim.cmd('luafile ' .. vim.fn.stdpath('config') .. '/init.lua')
    -- Optional: add a notification
    vim.notify('Nvim config reloaded!', vim.log.levels.INFO, { title = 'Config' })
  end,
})

local temporary_view_group = vim.api.nvim_create_augroup('AutoCloseTemporaryView', { clear = true })
local pending_jump

vim.api.nvim_create_autocmd('User', {
  group = temporary_view_group,
  pattern = 'LspDefinition',
  callback = function()
    local jump = {
      source = vim.api.nvim_get_current_buf(),
      existing = {},
    }
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      jump.existing[bufnr] = true
    end
    pending_jump = jump

    vim.defer_fn(function()
      if pending_jump == jump then
        pending_jump = nil
      end
    end, 2000)
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = temporary_view_group,
  callback = function(args)
    if not pending_jump
      or args.buf == pending_jump.source
      or pending_jump.existing[args.buf]
      or vim.bo[args.buf].buftype ~= ''
      or vim.api.nvim_buf_get_name(args.buf) == '' then
      return
    end

    vim.b[args.buf].auto_close_temporary_view = true
    pending_jump = nil
  end,
})

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'BufWritePost' }, {
  group = temporary_view_group,
  callback = function(args)
    if vim.b[args.buf].auto_close_temporary_view then
      vim.b[args.buf].auto_close_temporary_view = false
    end
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  group = temporary_view_group,
  callback = function(args)
    if not vim.b[args.buf].auto_close_temporary_view or vim.bo[args.buf].modified then
      return
    end

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf)
        and vim.b[args.buf].auto_close_temporary_view
        and not vim.bo[args.buf].modified
        and #vim.fn.win_findbuf(args.buf) == 0 then
        vim.api.nvim_buf_delete(args.buf, { force = false })
      end
    end)
  end,
})
