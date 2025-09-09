-- Project-specific LazyVim configuration  
-- Configure snacks picker to only search in lib/ directory and root level files

-- Override the default files picker for this project
local function project_files_picker()
  require("snacks").picker.files({
    finder = { "find", ".", "-maxdepth", "1", "-type", "f", "-o", "-path", "./lib/*", "-type", "f" },
    cwd = vim.fn.getcwd()
  })
end

vim.keymap.set("n", "<leader>ff", project_files_picker, { desc = "Find Files (lib/ and root only)" })
vim.keymap.set("n", "<leader> ", project_files_picker, { desc = "Find Files (lib/ and root only)" })