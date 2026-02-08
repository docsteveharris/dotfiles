return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts = opts or {}
    opts.picker = opts.picker or {}
    opts.picker.files = opts.picker.files or {}

    -- Ensure dotfiles are included
    opts.picker.files.hidden = true

    -- Force fd to include hidden files and still ignore .git directory
    opts.picker.files.cmd = "fd"
    opts.picker.files.args = {
      "--hidden",
      "--follow",
      "--exclude",
      ".git",
    }

    -- If you also want to include files ignored by .gitignore, uncomment:
    -- table.insert(opts.picker.files.args, "--no-ignore")

    return opts
  end,
}
