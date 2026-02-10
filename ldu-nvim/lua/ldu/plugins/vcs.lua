return {
  "mhinz/vim-signify",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.g.signify_update_on_bufenter = 1
    vim.g.signify_update_on_focusgained = 1
    vim.g.signify_update_on_insert_leave = 1

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function() pcall(vim.cmd, "silent! SignifyUpdate") end,
    })

    vim.g.signify_vcs_list = { "hg" }
    vim.g.signify_sign_add = "⠀"
    vim.g.signify_sign_delete = "⠀"
    vim.g.signify_sign_delete_first_line = "⠀"
    vim.g.signify_sign_change = "⠀"
    vim.g.signify_sign_changedelete = "⠀"

    -- Use tokyonight-consistent colors for sign column highlights
    vim.api.nvim_set_hl(0, "SignifySignChange", { bg = "#394b70" })
    vim.api.nvim_set_hl(0, "SignifySignChangeDelete", { bg = "#394b70" })

    vim.keymap.set("n", "]c", "<plug>(signify-next-hunk)", { silent = true, desc = "Next hunk" })
    vim.keymap.set("n", "[c", "<plug>(signify-prev-hunk)", { silent = true, desc = "Prev hunk" })
    vim.keymap.set("n", "<leader>ghp", ":SignifyHunkDiff<cr>", { desc = "Preview Hunk" })
    vim.keymap.set("n", "<leader>ghu", ":SignifyHunkUndo<cr>", { desc = "Undo Hunk" })
    vim.keymap.set("n", "<leader>ghl", ":SignifyToggleHighlight<cr>", { desc = "Toggle Line Highlight" })
  end,
}
