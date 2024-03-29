-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
-- vim.g.nvim_tree_icons = {
-- 	default = "",
-- 	symlink = "",
-- 	git = {
-- 		unstaged = "",
-- 		staged = "S",
-- 		unmerged = "",
-- 		renamed = "➜",
-- 		deleted = "",
-- 		untracked = "U",
-- 		ignored = "◌",
-- 	},
-- 	folder = {
-- 		default = "",
-- 		open = "",
-- 		empty = "",
-- 		empty_open = "",
-- 		symlink = "",
-- 	},
-- }
--
-- vim.g.nvim_tree_highlight_opened_files = 1
-- vim.g.nvim_tree_add_trailing = 1
-- vim.g.nvim_tree_group_empty = 1

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	vim.notify("nvim-tree not found!")
	return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	vim.notify("nvim-tree.config not found!")
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	open_on_tab = false,
	hijack_cursor = true,
	update_cwd = true,
	renderer = {
		indent_markers = {
			enable = true,
		},
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 30,
		height = 30,
		hide_root_folder = true,
		side = "left",
		mappings = {
			custom_only = false,
			list = {
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
				{ key = "b", cb = tree_cb("split") },
			},
		},
		number = false,
		relativenumber = false,
		signcolumn = "yes",
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
})
