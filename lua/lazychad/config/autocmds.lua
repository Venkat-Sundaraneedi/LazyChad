-- This file is automatically loaded by lazychad.config.init.

-- //========== autocmds ==========//

local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command

-- themes
cmd("Nvthemes", function()
  require("nvchad.themes").open()
end, { desc = "Open NvChad themes with Telescope" })

local function augroup(name)
  return vim.api.nvim_create_augroup("lazychad_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazychad_last_loc then
      return
    end
    vim.b[buf].lazychad_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- -- Autocommand to prevent reopening of specific buffers
-- autocmd({ "BufLeave", "BufUnload", "BufDelete" }, {
--   pattern = "*", -- Apply to all buffers
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local bufname = vim.api.nvim_buf_get_name(bufnr)
--
--     -- Check if the buffer name contains "health", "lspinfo", or "conforminfo"
--     if string.find(bufname, "health") or string.find(bufname, "lspinfo") or string.find(bufname, "conforminfo") then
--       -- Prevent the buffer from being listed (hidden from buffer list)
--       vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
--
--       -- Optionally, clear the buffer contents to ensure it's truly gone
--       -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
--       -- This line is commented out because it might not be desirable in all cases.
--       -- It completely clears the buffer's content.
--
--       print("Preventing buffer from reopening: " .. bufname)
--     end
--   end,
-- })

-- autocmd to be in normal mode when opening lazygit
autocmd({ "TermOpen", "BufEnter" }, {
  pattern = "term://*",
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)

    if not string.find(bufname, "lazygit") then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "n", true)
    end
  end,
})

-- autocmd to refresh json file when it changes
autocmd("FileChangedShell", {
  pattern = "*.json",
  command = "checktime",
})

-- autocmd to set the cursor to the last change of the file
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if
      line > 1
      and line <= vim.fn.line("$")
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd('normal! g`"')
    end
  end,
})

-- autocmd to disable cmp when in prompt
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "[Prompt]",
  callback = function()
    require("cmp").setup({
      enabled = false,
    })
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "[Prompt]",
  callback = function()
    require("cmp").setup({
      enabled = true,
    })
  end,
})
