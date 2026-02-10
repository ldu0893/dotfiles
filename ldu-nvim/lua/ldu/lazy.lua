local fn = vim.fn
local uv = vim.uv or vim.loop

local base = fn.stdpath("data") .. "/lazy"
local lazypath = base .. "/lazy.nvim"

if not uv.fs_stat(lazypath) then
  fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "ldu.plugins" },
  },

  root = base,
  lockfile = fn.stdpath("config") .. "/lazy-lock.json",
})
