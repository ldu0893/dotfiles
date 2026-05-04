vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.updatetime = 100

vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.undofile = true

-- Mouse: enable + copy visual selection to clipboard on release
vim.opt.mouse = "a"

-- Use OSC 52 for clipboard (works over SSH/tmux)
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- On mouse release in visual mode, yank selection to system clipboard
vim.keymap.set("v", "<LeftRelease>", '"+y', { noremap = true })
local function yank_after_delay(select_cmd, delay)
  return function()
    vim.cmd("normal! " .. select_cmd)
    vim.defer_fn(function()
      vim.cmd('normal! "+y')
    end, delay)
  end
end
vim.keymap.set("n", "<2-LeftMouse>", yank_after_delay("viw", 150), { noremap = true })
vim.keymap.set("n", "<3-LeftMouse>", yank_after_delay("V", 350), { noremap = true })

-- Disable expensive features for large files (>1 MB)
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if not ok or not stats or stats.size < 1024 * 1024 then
      return
    end

    vim.b[args.buf].large_file = true

    -- disable syntax highlighting and treesitter
    vim.api.nvim_create_autocmd("BufReadPost", {
      buffer = args.buf,
      once = true,
      callback = function()
        vim.cmd("syntax off")
        pcall(vim.treesitter.stop, args.buf)
      end,
    })

    -- disable LSP for this buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      buffer = args.buf,
      callback = function(a)
        vim.schedule(function()
          pcall(vim.lsp.buf_detach_client, args.buf, a.data.client_id)
        end)
      end,
    })

    -- disable format-on-save, diagnostics, and cursorline
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.cursorline = false
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.spell = false
  end,
})
