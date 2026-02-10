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
vim.keymap.set("v", "<LeftRelease>", '"+y', { noremap = true })

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
