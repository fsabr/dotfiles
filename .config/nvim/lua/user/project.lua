local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
	return
end

project.setup({
	active = true,
	on_config_done = nil,
	manual_mode = false,
	detection_methods = { "pattern" },
	patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

	---@ Show hidden files in telescope when searching for files in a project
	show_hidden = false,

	---@usage When set to false, you will get a message when project.nvim changes your directory.
	-- When set to false, you will get a message when project.nvim changes your directory.
	silent_chdir = true,

	---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
	ignore_lsp = {},

	---@type string
	---@usage path to store the project history for use in telescope
  datapath = vim.fn.stdpath("data"),
})

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
	return
end

telescope.load_extension('projects')
