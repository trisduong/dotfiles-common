-- set tab to 3 space when entering a buffer with .lua file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.lua" },
  callback = function()
    vim.opt.shiftwidth = 3
    vim.opt.tabstop = 3
    vim.opt.softtabstop = 3
    vim.opt.expandtab = true  -- Use spaces instead of tabs
    vim.opt.autoindent = true -- Keep indentation level of the previous line
  end,
})

-- set tab to 4 space when entering a buffer with .py file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.py" },
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true  -- Use spaces instead of tabs
    vim.opt.autoindent = true -- Keep indentation level of the previous line
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.go" },
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true
    vim.opt.autoindent = true
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

-- Auto-close third-party/site package files after inspection
local close_group = vim.api.nvim_create_augroup('AutoCloseThirdParty', { clear = true })

-- Track the buffer we came from when using gd
local source_buffer = nil

-- Function to check if a file path is from a third-party package
local function is_third_party_file(filepath)
  if not filepath then return false end
  
  local patterns = {
    'site%-packages/',     -- Python site-packages
    'node_modules/',       -- Node.js modules
    '/usr/lib/',          -- System libraries
    '/usr/include/',      -- System headers
    '%.cargo/registry/',   -- Rust crates
    '/go/pkg/mod/',       -- Go modules
    '%.local/lib/',       -- Local libraries
    'venv/lib/',          -- Python virtual environments
    'env/lib/',           -- Python environments
  }
  
  for _, pattern in ipairs(patterns) do
    if filepath:match(pattern) then
      return true
    end
  end
  
  return false
end

-- Hook into LSP definition to track source buffer
vim.api.nvim_create_autocmd('User', {
  group = close_group,
  pattern = 'LspDefinition',
  callback = function()
    source_buffer = vim.api.nvim_get_current_buf()
  end,
})

-- Auto-close third-party files when leaving them
vim.api.nvim_create_autocmd('BufLeave', {
  group = close_group,
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(current_buf)
    
    -- Only close if it's a third-party file and we're not staying in the same file
    if is_third_party_file(filepath) and source_buffer and source_buffer ~= current_buf then
      -- Delay the close to ensure we've actually left the buffer
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(current_buf) then
          -- Only close if the buffer is still showing the third-party file
          local current_filepath = vim.api.nvim_buf_get_name(current_buf)
          if current_filepath == filepath and vim.api.nvim_get_current_buf() ~= current_buf then
            vim.api.nvim_buf_delete(current_buf, { force = false })
          end
        end
      end, 100)
    end
  end,
})

-- Alternative approach: Auto-close after a timeout when viewing third-party files
vim.api.nvim_create_autocmd('BufEnter', {
  group = close_group,
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(current_buf)
    
    if is_third_party_file(filepath) then
      -- Set a timer to auto-close after 30 seconds of inactivity
      local timer = vim.loop.new_timer()
      if timer then
        timer:start(30000, 0, vim.schedule_wrap(function()
          if vim.api.nvim_buf_is_valid(current_buf) and vim.api.nvim_get_current_buf() ~= current_buf then
            local buf_filepath = vim.api.nvim_buf_get_name(current_buf)
            if is_third_party_file(buf_filepath) then
              vim.api.nvim_buf_delete(current_buf, { force = false })
            end
          end
          timer:close()
        end))
        
        -- Cancel timer if buffer becomes active again
        vim.api.nvim_create_autocmd('BufEnter', {
          buffer = current_buf,
          once = true,
          callback = function()
            if timer and not timer:is_closing() then
              timer:close()
            end
          end,
        })
      end
    end
  end,
})
